# frozen_string_literal: true

# == Schema Information
#
# Table name: transactions
#
#  id                        :bigint           not null, primary key
#  amount_cents              :bigint           default(0), not null
#  amount_currency           :string(3)        default("BRL"), not null
#  competency_date           :date
#  description               :text
#  document_number           :string
#  due_date                  :date             not null
#  exchanged_amount_cents    :bigint           default(0), not null
#  exchanged_amount_currency :string(3)        default("BRL"), not null
#  installment_number        :integer
#  installment_total         :integer
#  installment_type_cd       :integer
#  name                      :string
#  paid                      :boolean          default(FALSE), not null
#  paid_at                   :datetime
#  payment_method_cd         :integer          default(0), not null
#  payment_type_cd           :integer          default(0), not null
#  transaction_type_cd       :integer          default(0), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  account_id                :bigint           not null
#  bank_account_id           :bigint           not null
#  category_id               :bigint
#  contact_id                :bigint
#  cost_center_id            :bigint
#  import_id                 :bigint
#  installment_source_id     :bigint
#  transfer_to_id            :bigint
#
# Indexes
#
#  index_transactions_on_account_id             (account_id)
#  index_transactions_on_bank_account_id        (bank_account_id)
#  index_transactions_on_category_id            (category_id)
#  index_transactions_on_contact_id             (contact_id)
#  index_transactions_on_cost_center_id         (cost_center_id)
#  index_transactions_on_due_date               (due_date)
#  index_transactions_on_import_id              (import_id)
#  index_transactions_on_installment_source_id  (installment_source_id)
#  index_transactions_on_installment_type_cd    (installment_type_cd)
#  index_transactions_on_paid                   (paid)
#  index_transactions_on_payment_method_cd      (payment_method_cd)
#  index_transactions_on_payment_type_cd        (payment_type_cd)
#  index_transactions_on_transaction_type_cd    (transaction_type_cd)
#  index_transactions_on_transfer_to_id         (transfer_to_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (bank_account_id => bank_accounts.id)
#  fk_rails_...  (category_id => domains.id)
#  fk_rails_...  (contact_id => people.id)
#  fk_rails_...  (cost_center_id => domains.id)
#  fk_rails_...  (import_id => imports.id)
#  fk_rails_...  (installment_source_id => transactions.id)
#  fk_rails_...  (transfer_to_id => bank_accounts.id)
#
class Transaction < ApplicationRecord
  include Transactions::Searchable
  include Transactions::Constants
  include Transactions::Scopes
  include Attachable
  include Auditable

  acts_as_taggable
  acts_as_taggable_tenant :account_id

  as_enum :transaction_type, TRANSACTION_TYPES
  as_enum :payment_method, PAYMENT_METHOD
  as_enum :payment_type, PAYMENT_TYPE
  as_enum :installment_type, INSTALLMENT_TYPE

  monetize :amount_cents, :exchanged_amount_cents

  has_noticed_notifications

  # Scopes
  scope :only_paid,        -> { where(paid: true) }
  scope :only_unpaid,      -> { where(paid: false) }
  scope :revenues,         -> { where(transaction_type_cd: 0) }
  scope :expenses,         -> { where(transaction_type_cd: [1, 2, 3, 4]) }
  scope :transfers,        -> { where(transaction_type_cd: 5) }
  scope :ignore_transfers, -> { where.not(transaction_type_cd: 5) }
  scope :paid_revenues,    -> { revenues.only_paid }
  scope :unpaid_revenues,  -> { revenues.only_unpaid }
  scope :paid_expenses,    -> { expenses.only_paid }
  scope :unpaid_expenses,  -> { expenses.only_unpaid }
  scope :paid_transfers,   -> { transfers.only_paid }
  scope :unpaid_transfers, -> { transfers.only_unpaid }

  # Queries due date
  scope :delayed,          -> { only_unpaid.where('due_date < ?', Current.date) }
  scope :last_day,         -> { only_unpaid.where('due_date = ?', Current.date) }
  scope :on_time,          -> { only_unpaid.where('due_date > ?', Current.date) }

  # Scopes grouped by due_date
  scope :paid_revenues_grouped_by, lambda { |period: :month|
    paid_revenues.group_by_period(period, :due_date, format: I18n.t('time.formats.month'), series: true, default_value: 0)
  }
  scope :unpaid_revenues_grouped_by, lambda { |period: :month|
    unpaid_revenues.group_by_period(period, :due_date, format: I18n.t('time.formats.month'), series: true, default_value: 0)
  }
  scope :paid_expenses_grouped_by, lambda { |period: :month|
    paid_expenses.group_by_period(period, :due_date, format: I18n.t('time.formats.month'), series: true, default_value: 0)
  }
  scope :unpaid_expenses_grouped_by, lambda { |period: :month|
    unpaid_expenses.group_by_period(period, :due_date, format: I18n.t('time.formats.month'), series: true, default_value: 0)
  }

  # Associations
  belongs_to :account
  belongs_to :bank_account
  belongs_to :transfer_to, class_name: 'BankAccount', optional: true
  belongs_to :contact,     -> { with_discarded }, optional: true, inverse_of: :transactions
  belongs_to :category,    -> { with_discarded }, optional: true, inverse_of: :transactions
  belongs_to :cost_center, -> { with_discarded }, optional: true, inverse_of: :transactions
  belongs_to :installment_source, class_name: 'Transaction', optional: true
  belongs_to :import, optional: true

  has_many :installments, class_name: 'Transaction',
                          foreign_key: :installment_source_id,
                          inverse_of: :installment_source

  # Validators
  validates :due_date, presence: true
  validates :transfer_to, presence: { if: :transfer? }

  # Callbacks
  before_validation :set_exchanged_amount, if: :amount_cents_changed?

  # Turbo streams callbacks
  # broadcasts_to ->(_transaction) { :transactions }, inserts_by: :prepend

  def amount_cents=(value)
    super(TransactionsHelper.parse_str_to_cents(value:))
  end

  def exchanged_amount_cents=(value)
    super(TransactionsHelper.parse_str_to_cents(value:))
  end

  def same_currency?
    exchanged_amount_currency == amount_currency
  end

  def expense?
    %i[fixed_expense variable_expense payroll tax].include?(transaction_type)
  end

  def unpaid?
    !paid?
  end

  def child_transactions
    account.transactions.where(installment_source_id: id).where.not(id:)
  end

  def sibling_transactions
    account.transactions.where(installment_source_id:).where.not(id:).order(:id)
  end

  def next_transactions
    account.transactions.where(installment_source_id:).where('id > ?', id).order(:id)
  end

  def prev_transactions
    account.transactions.where(installment_source_id:).where('id < ?', id).order(:id)
  end

  def all_transactions
    account.transactions.where(installment_source_id:).order(:id)
  end

  def installment_source?
    id == installment_source_id
  end

  def self.duplicatable_attributes
    column_names - %w[id document_number competency_date created_at updated_at installment_number installment_total
                      installment_type_cd installment_source_id payment_type_cd]
  end

  def delayed?
    due_date < Current.date && unpaid?
  end

  def delay_in_days
    (due_date - Current.date).to_i
  end

  def due_today?
    due_date == Current.date && unpaid?
  end

  private

  # Callback para fazer a conversão do amount para o exchanged_amount (moeda padrão do usuário)
  def set_exchanged_amount
    self.exchanged_amount =
      if same_currency?
        amount
      else
        amount.exchange_to(Money.default_currency)
      end
  end
end
