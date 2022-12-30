# frozen_string_literal: true

module Transactions
  class Toggle < ApplicationInteractor
    def call
      ActiveRecord::Base.transaction do
        if context.transaction.paid?
          context.transaction.update(paid: false, paid_at: nil)
        else
          context.transaction.update(paid: true, paid_at: DateTime.current)
        end

        set_feedback_message
      end

      context.transaction.bank_account.update_balance!
      context.transaction.transfer_to.update_balance! if context.transaction.transfer?
    end

    private

    def set_feedback_message
      if context.transaction.errors.any?
        context.fail!(message: I18n.t('transactions.toggle.error'))
      else
        context.message = I18n.t('transactions.toggle.success')
      end
    end
  end
end
