# frozen_string_literal: true

module Transactions
  class Update < ApplicationInteractor
    def call
      ActiveRecord::Base.transaction do
        context.transaction.update(transaction_params)
        set_feedback_message
      end

      # Se não foi alterado nada, dá um skip no calculo do saldo
      unless context.transaction.paid_previously_changed? || (context.transaction.paid? && context.transaction.amount_cents_previously_changed?)
        return
      end

      context.transaction.bank_account.update_balance!
      context.transaction.transfer_to.update_balance! if context.transaction.transfer?
      context.transaction.account.update_balance!
    end

    private

    def set_feedback_message
      if context.transaction.errors.any?
        context.fail!(message: context.transaction.errors.full_messages.first)
      else
        context.message = I18n.t('transactions.update.success')
      end
    end

    def transaction_params
      context.transaction_params
             .except(:contact_id, :category_id, :cost_center_id)
             .merge(secure_relationship_params)
    end

    def secure_relationship_params
      bank_accounts = context.account.bank_accounts

      secure_params = {
        contact: context.account.contacts.find_by(id: context.transaction_params.fetch(:contact_id, nil)),
        category: context.account.categories.find_by(id: context.transaction_params.fetch(:category_id, nil)),
        cost_center: context.account.cost_centers.find_by(id: context.transaction_params.fetch(:cost_center_id, nil))
      }

      if context.transaction.transfer?
        secure_params[:bank_account] = bank_accounts.find_by(
          id: context.transaction_params.fetch(:bank_account_id, nil)
        )
        secure_params[:transfer_to] = bank_accounts.find_by(
          id: context.transaction_params.fetch(:transfer_to_id, nil)
        )
      end

      secure_params
    end
  end
end
