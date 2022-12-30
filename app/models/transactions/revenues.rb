# frozen_string_literal: true

module Transactions
  class Revenues < ApplicationInteractor
    def call
      query = context.account.transactions.where(
        bank_account: context.bank_account,
        due_date: context.period
      )

      paid_revenues = Money.from_cents(query.paid_revenues.sum(:exchanged_amount_cents))
      expected_revenues = Money.from_cents(query.revenues.sum(:exchanged_amount_cents))
      percentage = CalculationsHelper.calculate_percentage(paid_revenues.to_f, expected_revenues.to_f)

      context.result = [paid_revenues, expected_revenues, percentage]
    end
  end
end
