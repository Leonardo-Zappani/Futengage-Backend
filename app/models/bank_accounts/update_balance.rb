# frozen_string_literal: true

module BankAccounts
  class UpdateBalance < ApplicationInteractor
    def call
      context.bank_account.update!(balance_cents: recalculate_balance_cents)
      context.bank_account.account.update!(balance_cents: context.bank_account.account.bank_accounts.sum(:balance_cents))
      set_feedback_message
    end

    private

    def set_feedback_message
      if context.bank_account.errors.any?
        context.fail!(message: context.bank_account.errors.full_messages.first)
      else
        context.message = I18n.t('bank_accounts.update.success')
      end
    end

    def recalculate_balance_cents
      context.bank_account.initial_balance_cents + (
        (sum_revenues + sum_revenue_transfers) - (sum_expenses + sum_expense_transfers)
      )
    end

    def sum_revenues
      context.bank_account.transactions.paid_revenues.sum(:exchanged_amount_cents)
    end

    def sum_expenses
      context.bank_account.transactions.paid_expenses.sum(:exchanged_amount_cents)
    end

    def sum_revenue_transfers
      context.bank_account.transactions_as_recipient.paid_transfers.sum(:exchanged_amount_cents)
    end

    def sum_expense_transfers
      context.bank_account.transactions.paid_transfers.sum(:exchanged_amount_cents)
    end
  end
end
