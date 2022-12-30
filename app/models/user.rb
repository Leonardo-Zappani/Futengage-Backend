# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  accepted_privacy_at    :datetime
#  accepted_terms_at      :datetime
#  admin                  :boolean          default(FALSE), not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  preferred_language     :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  time_zone              :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  account_id             :bigint           not null
#
# Indexes
#
#  index_users_on_account_id            (account_id)
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
class User < ApplicationRecord
  include UserAgreements
  include UserInvitable
  include Auditable

  acts_as_tagger
  has_person_name

  devise :confirmable, :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  as_enum :preferred_language, I18n.available_locales, map: :string, source: :preferred_language

  belongs_to :account, optional: true

  has_many :account_users, dependent: :delete_all
  has_many :accounts, through: :account_users
  has_many :notifications, as: :recipient, dependent: :delete_all

  has_one_attached :avatar

  accepts_nested_attributes_for :account, reject_if: :all_blank

  after_create :set_owner_to_account, if: :should_set_owner_to_account?
  after_create :create_default_personal_account

  def pending_invitations?
    AccountInvitation.exists?(email:)
  end

  def pending_invitations
    AccountInvitation.where(email:).where.not(account:)
  end

  def owner?
    account.owner_id = id
  end

  def business_account?
    accounts.exists?(account_type_cd: Account::ACCOUNT_TYPES[:business])
  end

  private

  def should_set_owner_to_account?
    account.owner_id.blank?
  end

  def set_owner_to_account
    return unless should_set_owner_to_account?

    account.update!(owner: self)
  end

  def create_default_personal_account
    company = Company.create!(name:, email:)
    account = Account.create!(owner: self, company:, account_type: :personal)
    account.account_users.create!(user: self, role: :admin)
  end
end
