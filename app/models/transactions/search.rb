# frozen_string_literal: true

module Transactions
  class Search < ApplicationInteractor
    def call
      context.query = context.account.transactions.includes(:attachments_attachments).where(
        due_date: context.period,
        transaction_type_cd: transaction_type_cd(context.transaction_type)
      ).sort_by_params(context.sort_column, context.sort_direction)

      context.query = context.query.search_by_q(context.q) if context.q.present?
      context.query = if context.transaction_type == :transfer
                        context.query.includes(:bank_account, :transfer_to)
                               .where('? in (bank_account_id, transfer_to_id)', context.bank_account)
                      else
                        context.query.includes(:contact, :category).where(bank_account: context.bank_account)
                      end
    end

    private

    def transaction_type_cd(transaction_type)
      Transaction.transaction_types[transaction_type.to_sym]
    end
  end
end
