# frozen_string_literal: true

class ReportsController < ApplicationController

  before_action :bank_account,
                # GET /reports
    def index
      calculations_dre if params[:graph] == "dre_graph" || !params[:graph].present?
      @response = Reports::Processor.call(params: params, bank_account: @bank_account, paid: set_paid, account: current_account).result if params[:graph] != "dre_graph" && params[:graph].present?
      return @response
    end

  private

  def calculations_dre
    transactions = Reports::Processor.call(params: params, bank_account: @bank_account, paid: set_paid, account: current_account).result

    gross_income = Money.from_cents(transactions.where(transaction_type_cd: 0).sum(:exchanged_amount_cents))
    taxes = Money.from_cents(transactions.where(transaction_type_cd: 4).sum(:exchanged_amount_cents) * -1)
    variable_expense = Money.from_cents(transactions.where(transaction_type_cd: 2).sum(:exchanged_amount_cents) * -1)
    fixed_expense = Money.from_cents(transactions.where(transaction_type_cd: 1).sum(:exchanged_amount_cents) * -1)
    personnel_expenses = Money.from_cents(transactions.where(transaction_type_cd: 3).sum(:exchanged_amount_cents) * -1)

    gross_profit = gross_income + taxes
    operating_profit = gross_profit + variable_expense
    result = operating_profit + personnel_expenses + fixed_expense

    @response = { gross_income:, taxes:, variable_expense:, fixed_expense:, personnel_expenses:,
                  gross_profit:, operating_profit:, result: }
  end

  def set_paid

    if params[:paid] == params[:not_paid]
      nil
    elsif params[:paid] == "1"
      true
    elsif params[:not_paid] == "1"
      false
    end
  end

  def bank_account

    if params[:bank_accounts].present? && params[:bank_accounts].select { |i| i != "" }.present?
      @bank_account = current_account.bank_accounts.where(id: params[:bank_accounts])
    else
      @bank_account = current_account.bank_accounts.where(default: true)
    end
  end

end
