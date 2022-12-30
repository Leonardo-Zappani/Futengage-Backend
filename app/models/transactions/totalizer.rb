# frozen_string_literal: true

module Transactions
  class Totalizer < ApplicationInteractor
    def call
      query = context.account.transactions.where(
        bank_account: context.bank_account,
        due_date: context.period,
        transaction_type_cd: Transaction.transaction_types[context.transaction_type]
      )

      total = Money.from_cents(query.sum(:exchanged_amount_cents))
      total_paid = Money.from_cents(query.only_paid.sum(:exchanged_amount_cents))
      total_unpaid = Money.from_cents(query.only_unpaid.sum(:exchanged_amount_cents))

      context.result = [total, total_paid, total_unpaid]
    end
  end
end
