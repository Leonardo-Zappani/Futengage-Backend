# frozen_string_literal: true

# == Schema Information
#
# Table name: bank_accounts
#
#  id                       :bigint           not null, primary key
#  account_type_cd          :integer          default(0), not null
#  balance_cents            :bigint           default(0), not null
#  balance_currency         :string(3)        default("BRL"), not null
#  default                  :boolean          default(FALSE), not null
#  initial_balance_cents    :bigint           default(0), not null
#  initial_balance_currency :string(3)        default("BRL"), not null
#  name                     :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  account_id               :bigint           not null
#
# Indexes
#
#  index_bank_accounts_on_account_id       (account_id)
#  index_bank_accounts_on_account_type_cd  (account_type_cd)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
class BankAccount < ApplicationRecord
  include BankAccounts::Searchable
  include Auditable

  ACCOUNT_TYPES = {
    current_account: 0,   # conta corrente
    savings_account: 1,   # conta poupança
    salary_account: 2,    # conta salário
    investing_account: 3, # conta investimento
    cash_account: 4,      # caixa / carteira
    other: 5
  }.freeze

  acts_as_tenant :account

  as_enum :account_type, ACCOUNT_TYPES

  monetize :initial_balance_cents
  monetize :balance_cents

  belongs_to :account

  has_many :transactions
  has_many :transactions_as_recipient, class_name: 'Transaction', foreign_key: :transfer_to_id

  validates :name, presence: true
  validates :default, uniqueness: { scope: :account_id }, if: :default?

  before_validation on: :update do
    without_auditing do
      other_bank_accounts.update!(default: false) if default_changed?
    end
  end

  after_update :update_balance!, if: :initial_balance_cents_previously_changed?

  def initial_balance_cents=(value)
    super(TransactionsHelper.parse_str_to_cents(value:))
  end

  def balance_cents=(value)
    super(TransactionsHelper.parse_str_to_cents(value:))
  end

  def update_balance!
    reload
    without_auditing do
      update!(balance_cents: recalculate_balance_cents)
    end
  end

  def other_bank_accounts
    account.bank_accounts.where.not(id: self)
  end

  private

  def recalculate_balance_cents
    initial_balance_cents + ((sum_revenues + sum_revenue_transfers) - (sum_expenses + sum_expense_transfers))
  end

  def sum_revenues
    account.transactions.paid_revenues.where(bank_account: self).sum(:exchanged_amount_cents)
  end

  def sum_expenses
    account.transactions.paid_expenses.where(bank_account: self).sum(:exchanged_amount_cents)
  end

  def sum_revenue_transfers
    account.transactions.paid_transfers.where(transfer_to: self).sum(:exchanged_amount_cents)
  end

  def sum_expense_transfers
    account.transactions.paid_transfers.where(bank_account: self).sum(:exchanged_amount_cents)
  end
end
