# frozen_string_literal: true

module Transactions
  class DropdownActionsComponent < ApplicationComponent
    def initialize(transaction:, month:)
      @transaction = transaction
      @month = month
      super
    end
  end
end
