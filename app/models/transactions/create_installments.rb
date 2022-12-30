# frozen_string_literal: true

module Transactions
  # Class de serviço responsável por criar as parcelas a partir de uma transação já existente
  class CreateInstallments < ApplicationInteractor
    def call
      ActiveRecord::Base.transaction do
        amount_cents = TransactionsHelper.parse_str_to_cents(
          value: context.create_installments_params.fetch(:amount_cents, 0)
        )
        amount_currency          = context.create_installments_params.fetch(:amount_currency, 'BRL')
        installment_total        = context.create_installments_params.fetch(:installment_total, 1).to_i
        installment_amount_cents = amount_cents.zero? ? 0 : (amount_cents / installment_total)
        installment_type         = context.create_installments_params.fetch(:installment_type, :monthly)

        # returns if installment total is not greater than 1
        return unless installment_total > 1

        # Update current transaction
        context.transaction.update(
          amount_cents: installment_amount_cents,
          payment_type: :installment,
          amount_currency:,
          installment_number: 1,
          installment_total:,
          installment_type:,
          installment_source_id: context.transaction.id
        )

        # Return if error
        return context.fail!(message: context.transaction.errors.full_messages.first) if context.transaction.errors.any?

        # Create other transactions
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
