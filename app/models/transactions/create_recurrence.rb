# frozen_string_literal: true

module Transactions
  # Class de serviço responsável por criar as transações recorrentes a partir de uma transação já existente
  class CreateRecurrence < ApplicationInteractor
    def call
      ActiveRecord::Base.transaction do
        installment_total        = context.create_recurrence_params.fetch(:installment_total, 1).to_i
        installment_type         = context.create_recurrence_params.fetch(:installment_type, :monthly)

        # returns if installment total is not greater than 1
        return unless installment_total > 1

        # Update current transaction
        context.transaction.update(
          payment_type: :recurrent,
          installment_number: 1,
          installment_total:,
          installment_type:,
          installment_source_id: context.transaction.id
        )

        # Return if error
        return context.fail!(message: context.transaction.errors.full_messages.first) if context.transaction.errors.any?

        # Create other transactions like current transaction
        (2..installment_total.to_i).each do |installment_number|
          transaction = context.account.transactions.create(
            attributes.merge(
              due_date: TransactionsHelper.calculate_due_date(
                transaction: context.transaction,
                installment_number: (installment_number - 1)
              ),
              installment_number:,
              installment_source_id: context.transaction.id,
              paid: false,
              paid_at: nil
            )
          )
          return context.fail!(message: transaction.errors.full_messages.first) if transaction.errors.any?
        end

        context.message = I18n.t('transactions.update.success')
      end

      if context.transaction.paid?
        context.transaction.bank_account.update_balance!
        context.transaction.transfer_to.update_balance! if context.transaction.transfer?
        context.transaction.account.update_balance!
      end
    end

    private

    def attributes
      context.transaction.attributes.except('id', 'document_number', 'competency_date')
    end
  end
end
