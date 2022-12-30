# frozen_string_literal: true

module Transactions
  class Duplicate < ApplicationInteractor
    def call
      ActiveRecord::Base.transaction do
        context.transaction = context.account.transactions.create(duplicate_transaction_params)
        set_feedback_message
      end

      if context.transaction.paid?
        context.transaction.bank_account.update_balance!
        context.transaction.transfer_to.update_balance! if context.transaction.transfer?
        context.transaction.account.update_balance!
      end
    end

    private

    def set_feedback_message
      if context.transaction.errors.any?
        context.fail!(message: context.transaction.errors.full_messages.first)
      else
        context.message = I18n.t('transactions.duplicate.success')
      end
    end

    def duplicate_transaction_params
      context.transaction.attributes.slice(*Transaction.duplicatable_attributes)
    end
  end
end
