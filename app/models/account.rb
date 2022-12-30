# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id                    :bigint           not null, primary key
#  account_type_cd       :integer          default(0), not null
#  admin                 :boolean          default(FALSE), not null
#  balance_cents         :bigint           default(0), not null
#  balance_currency      :string(3)        default("BRL"), not null
#  country_code          :string(2)        default("BR")
#  default_currency      :string(3)        default("BRL")
#  discarded_at          :datetime
#  processor_plan_name   :string
#  subscription_status   :string           default("incomplete")
#  trial_ends_at         :date
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  company_id            :bigint           not null
#  owner_id              :bigint
#  processor_customer_id :string
#  processor_plan_id     :string
#
# Indexes
#
#  index_accounts_on_company_id    (company_id)
#  index_accounts_on_discarded_at  (discarded_at)
#  index_accounts_on_owner_id      (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => people.id)
#  fk_rails_...  (owner_id => users.id)
#
class Account < ApplicationRecord
  include Discardable

  audited associated_with: :company

  has_prefix_id :acct, override_find: false, override_param: false

  SUBSCRIPTION_STATUSES = {
    incomplete: 'incomplete',
    incomplete_expired: 'incomplete_expired',
    trialing: 'trialing',
    active: 'active',
    past_due: 'past_due',
    canceled: 'canceled',
    unpaid: 'unpaid'
  }.freeze

  ACCOUNT_TYPES = {
    business: 0,
    personal: 1,
    familiar: 2
  }.freeze

  as_enum :subscription_status, SUBSCRIPTION_STATUSES, map: :string, source: :subscription_status
  as_enum :account_type, ACCOUNT_TYPES
  monetize :balance_cents

  delegate :name, :first_name, :email, :phone_number, to: :company

  # BelongsTo Associations
  belongs_to :owner, class_name: 'User', optional: true
  belongs_to :company, dependent: :destroy

  # HasMany Associations
  has_many :account_invitations, dependent: :delete_all
  has_many :account_users, dependent: :delete_all
  has_many :users,         through:   :account_users
  has_many :contacts,      dependent: :delete_all
  has_many :bank_accounts, dependent: :delete_all
  has_many :categories,    dependent: :delete_all
  has_many :cost_centers,  dependent: :delete_all
  has_many :transactions,  dependent: :delete_all
  has_many :imports,       dependent: :delete_all

  accepts_nested_attributes_for :company, reject_if: :all_blank

  # Callbacks
  before_validation :set_trial_ends_at, on: :create

  after_create :create_default_bank_account,    if: :should_create_default_bank_account?
  after_update :update_customer_from_processor, if: :should_update_customer_from_processor?
  after_create :set_account_to_company

  # Public class methods
  def self.procfy_account
    find_by(admin: true)
  end

  # Public instance methods
  def default_bank_account
    bank_accounts.find_by(default: true)
  end

  def trial_period?
    # Se a conta for free, mas o owner está vinculado a pelo menos uma conta business
    return false if free?

    trialing? && trial_ends_at > Current.date
  end

  def free?
    procfy? || (personal? && owner.business_account?)
  end

  def trial_period_in_days
    (Current.date - trial_ends_at).to_i * -1
  end

  def subscribed?
    active? || procfy?
  end

  def update_balance!
    reload
    without_auditing do
      update!(balance_cents: bank_accounts.sum(:balance_cents))
    end
  end

  def procfy?
    admin?
  end

  def consumed_storage_size_in_bytes
    @consumed_storage_size_in_bytes ||= ActiveStorage::Attachment.joins(:blob).where(record: transactions).sum(:byte_size)
  end

  def max_storage_size_in_bytes
    5.gigabytes
  end

  def available_storage_in_bytes
    max_storage_size_in_bytes - consumed_storage_size_in_bytes
  end

  def available_storage_in_percentage
    return 0.to_f if consumed_storage_size_in_bytes.zero? || max_storage_size_in_bytes.zero?

    (consumed_storage_size_in_bytes.to_f / max_storage_size_in_bytes) * 100
  end

  # Private instance methods
  private

  def set_trial_ends_at
    return if personal?

    self.subscription_status = 'trialing'
    self.trial_ends_at = (Current.date + 30.days)
  end

  def should_create_default_bank_account?
    bank_accounts.empty?
  end

  def create_default_bank_account
    bank_accounts.create!(name: I18n.t('bank_accounts.default_name'), default: true)
  end

  def set_account_to_company
    return if company.account.present?

    company.update!(account: self)
  end

  def should_update_customer_from_processor?
    processor_customer_id.present? && (company.email_previously_changed? || company.first_name_previously_changed? || company.phone_number_previously_changed?)
  end

  def update_customer_from_processor
    return unless should_update_customer_from_processor?

    Stripe::Customer.update(processor_customer_id, { email:, name:, phone: phone_number })
  end
end
