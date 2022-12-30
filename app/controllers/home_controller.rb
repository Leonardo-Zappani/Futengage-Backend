# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :set_current_month
  before_action :set_current_bank_account
  before_action :set_current_transaction_type

  attr_reader :current_bank_account, :current_month, :current_transaction_type

  helper_method :current_month, :current_bank_account, :current_transaction_type

  def index; end

  # GET /home/outcome
  def outcome
    @outcome = Transactions::Outcome.call(
      account: Current.account,
      bank_account: current_bank_account,
      period: current_month.all_month
    ).result
  end

  # GET /home/revenues
  def revenues
    @paid_revenues, @expected_revenues, @percentage = Transactions::Revenues.call(
      account: Current.account,
      bank_account: current_bank_account,
      period: current_month.all_month
    ).result
  end

  # GET /home/expenses
  def expenses
    @paid_expenses, @expected_expenses, @percentage = Transactions::Expenses.call(
      account: Current.account,
      bank_account: current_bank_account,
      period: current_month.all_month
    ).result
  end

  # GET /home/chart
  def chart
    @column_data, @line_data = Transactions::Chart.call(
      account: Current.account,
      bank_account: current_bank_account,
      range_of_months: [(Current.date - 5.months).beginning_of_month..Current.date.end_of_month],
      period: :month
    ).result
  end

  # GET /home/new
  def new
    @transaction = current_account.transactions.new(
      due_date: current_month.change(day: Date.current.day),
      bank_account: current_bank_account,
      transaction_type: current_transaction_type,
      amount_currency: Money.default_currency
    )
  end

  # GET /home/dre
  def dre
    query = Current.account.transactions.where(
      bank_account: current_bank_account,
      due_date: current_month.all_month
    )

    @paid_revenues = Money.from_cents(query.paid_revenues.sum(:exchanged_amount_cents))
    @paid_tax_expenses = Money.from_cents(query.where(transaction_type_cd: 4).sum(:exchanged_amount_cents))
    @paid_var_expenses = Money.from_cents(query.where(transaction_type_cd: 2).sum(:exchanged_amount_cents))
    @paid_fixed_expenses = Money.from_cents(query.where(transaction_type_cd: 1).sum(:exchanged_amount_cents))
    @paid_payroll_expenses = Money.from_cents(query.where(transaction_type_cd: 3).sum(:exchanged_amount_cents))

    @gross_profit = (@paid_revenues - @paid_tax_expenses)
    @operating_profit = (@gross_profit - @paid_var_expenses)
    @net_profit = ((@operating_profit - @paid_fixed_expenses) - @paid_payroll_expenses)
  end


  private

  # Callbacks
  def set_current_month
    @current_month = if params[:month].present?
                       Date.parse(params[:month].to_s).beginning_of_month
                     else
                       Current.date.beginning_of_month
                     end
  end

  def set_current_bank_account
    @current_bank_account = if params[:bank_account_id].present?
                              current_account.bank_accounts.find(params[:bank_account_id])
                            else
                              current_account.default_bank_account
                            end
  end

  def set_current_transaction_type
    transaction_type = params[:transaction_type]&.to_sym
    @current_transaction_type = if transaction_type_defined?
                                  transaction_type
                                else
                                  :revenue
                                end
  end

  def set_current_required_params
    @current_required_params = {
      bank_account_id: current_bank_account&.id,
      month: current_month,
      transaction_type: current_transaction_type
    }
  end

  def transaction_types
    @transaction_types ||= Transaction.transaction_types
  end

  def transaction_type_defined?
    transaction_type = params[:transaction_type]&.to_sym
    transaction_type.present? && transaction_types.include?(transaction_type)
  end
end
