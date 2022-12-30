# frozen_string_literal: true

module Transactions
  module Constants
    extend ActiveSupport::Concern

    TRANSACTION_TYPES = {
      revenue: 0,
      fixed_expense: 1,
      variable_expense: 2,
      payroll: 3,
      tax: 4,
      transfer: 5
    }.freeze

    PAYMENT_TYPE = {
      on_cash: 0,
      installment: 1,
      recurrent: 2
    }.freeze

    PAYMENT_METHOD = {
      no_payment_method: 0,
      credit_card: 1,
      debit_card: 2,
      bank_slip: 3,
      check: 4,
      cash: 5,
      pix: 6,
      bank_transfer: 7
    }.freeze

    INSTALLMENT_TYPE = {
      daily: 0,
      weekly: 1,
      biweekly: 2,
      monthly: 3,
      bimonthly: 4,
      quarterly: 5,
      semiannual: 6,
      annual: 7
    }.freeze

    ACCEPTED_CURRENCIES = %i[BRL USD EUR GBP].freeze

    INSTALLMENT_ACTIONS = %i[only_this_installment this_and_next_installments prev_and_next_installments
                             this_and_prev_installments].freeze
  end
end
