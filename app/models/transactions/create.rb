module Transactions
  class Create < ApplicationInteractor
    def call
      ActiveRecord::Base.transaction do
        context.transaction = context.account.transactions.create(transaction_params)
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
        context.message = I18n.t('transactions.create.success')
      end
    end

    def transaction_params
      context.transaction_params
             .except(:bank_account_id, :contact_id, :category_id)
             .merge(secure_relationship_params)
    end

    def secure_relationship_params
      bank_accounts = context.account.bank_accounts
      {
        bank_account: bank_accounts.find_by(id: context.transaction_params.fetch(:bank_account_id)),
        transfer_to: bank_accounts.find_by(id: context.transaction_params.fetch(:transfer_to_id, nil)),
        contact: context.account.contacts.find_by(id: context.transaction_params.fetch(:contact_id, nil)),
        category: context.account.categories.find_by(id: context.transaction_params.fetch(:category_id, nil))
      }
    end
  end
end
