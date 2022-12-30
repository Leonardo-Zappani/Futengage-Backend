# frozen_string_literal: true

module Transactions
  class AttachmentsController < AttachmentsController
    protected

    # Use callbacks to share common setup or constraints between actions.
    def set_record
      @record = Current.account.transactions.find(params[:transaction_id])
    end
  end
end
