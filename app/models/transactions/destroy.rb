# frozen_string_literal: true

module Transactions
  class Destroy < ApplicationInteractor
    def call
      ActiveRecord::Base.transaction do
        case context.option.to_sym
        when :only_this_installment
          update_sibling_installments unless context.transaction.on_cash?
        when :this_and_next_installments
          context.transaction.next_transactions.destroy_all
          update_sibling_installments
        when :this_and_prev_installments
          context.transaction.prev_transactions.destroy_all
          update_sibling_installments
        when :prev_and_next_installments
          context.transaction.sibling_transactions.destroy_all
        end

        context.transaction.destroy
      end

      set_feedback_message

      if context.transaction.paid?
        context.transaction.bank_account.update_balance!
        context.transaction.transfer_to.update_balance! if context.transaction.transfer?
        context.transaction.account.update_balance!
      end
    end

    private

    def update_sibling_installments
      transaction_to_delete = context.transaction
      sibling_transactions_count = transaction_to_delete.sibling_transactions.count

      if sibling_transactions_count == 1
        return transaction_to_delete.sibling_transactions.update(
          payment_type_cd: 0,
          installment_type_cd: nil,
          installment_number: nil,
          installment_total: nil,
          installment_source_id: nil
        )
      end

      # Define a parcela de origem, se for o mesmo que está sendo deletado, então delega para a próxima parcela
      installment_source = transaction_to_delete.installment_source? ? transaction_to_delete.sibling_transactions.first : transaction_to_delete.installment_source

      # Atualiza todas as próximas parcelas (número da parcela e total)
      transaction_to_delete.sibling_transactions.find_each.with_index do |transaction, index|
        transaction.update(
          installment_number: (1 + index),
          installment_total: sibling_transactions_count,
          installment_source_id: installment_source.id
        )
      end

      # Atualiza a parcela que vai ser deletada setando NULL na coluna (installment_source_id)
      transaction_to_delete.update(installment_source_id: nil) if transaction_to_delete.installment_source?
    end

    def set_feedback_message
      if context.transaction.errors.any?
        context.fail!(message: context.transaction.errors.full_messages.first)
      else
        context.message = I18n.t('transactions.destroy.success')
      end
    end
  end
end
