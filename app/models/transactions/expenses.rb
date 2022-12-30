# frozen_string_literal: true

module Transactions
  class Expenses < ApplicationInteractor
    def call
      query = context.account.transactions.where(
        bank_account: context.bank_account,
        due_date: context.period
      )

      paid_expenses = Money.from_cents(query.paid_expenses.sum(:exchanged_amount_cents))
      expected_expenses = Money.from_cents(query.expenses.sum(:exchanged_amount_cents))
      percentage = CalculationsHelper.calculate_percentage(paid_expenses.to_f, expected_expenses.to_f)

      context.result = [paid_expenses, expected_expenses, percentage]
    end
  end
end
