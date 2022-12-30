# frozen_string_literal: true

module TransactionsHelper
  def amount_text_class(transaction, current_bank_account)
    return 'text-primary-500' if transaction.transfer? && transaction.transfer_to  == current_bank_account
    return 'text-danger-500'  if transaction.transfer? && transaction.bank_account == current_bank_account

    ''
  end

  def self.parse_str_to_cents(value:)
    if value.is_a?(String)
      value.gsub(/[,.]/, '').to_i
    else
      value
    end
  end

  def self.calculate_due_date(transaction:, installment_number:)
    case transaction.installment_type
    when :daily
      transaction.due_date + installment_number.days
    when :weekly
      transaction.due_date + installment_number.weeks
    when :biweekly
      transaction.due_date + (2 * installment_number.weeks)
    when :monthly
      transaction.due_date + installment_number.months
    when :bimonthly
      transaction.due_date + (2 * installment_number.months)
    when :quarterly
      transaction.due_date + (3 * installment_number.months)
    when :semiannual
      transaction.due_date + (6 * installment_number.months)
    else
      transaction.due_date + installment_number.years
    end
  end
end
