# frozen_string_literal: true

module Transactions
  class Outcome < ApplicationInteractor
    def call
      query = context.account.transactions.where(
        bank_account: context.bank_account,
        due_date: context.period
      )

      revenues_sum = Money.from_cents(query.revenues.sum(:exchanged_amount_cents))
      expenses_sum = Money.from_cents(query.expenses.sum(:exchanged_amount_cents))

      context.result = (revenues_sum - expenses_sum)
    end
  end
end
