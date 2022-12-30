module Reports
  module Charts
    class InPerDayGraph < ApplicationInteractor
      def call

        report = context.context
        account = report.account

        transactions = account.transactions
        transactions = transactions.where("transaction_type_cd = 0")
        transactions = transactions.where(bank_account_id: report.params[:bank_accounts].select { |i| i != '' }) if report.params[:bank_accounts].present? && report.params[:bank_accounts].count != 1
        transactions = transactions.where(bank_account: report.bank_account.first) if !report.params[:bank_accounts].present? || report.params[:bank_accounts].count == 1

        transactions = transactions.where("transactions.due_date >= :start_date", { start_date: report.params[:start_date].to_date }) if report.params[:start_date].present?
        transactions = transactions.where("transactions.due_date <= :end_date", { end_date: report.params[:end_date].to_date }) if report.params[:end_date].present?

        transactions = transactions.where("transactions.due_date >= :start_date", { start_date: Time.now.beginning_of_month.to_date }) unless report.params[:start_date].present?
        transactions = transactions.where("transactions.due_date <= :end_date", { end_date: Time.now.to_date }) unless report.params[:end_date].present?

        transactions = transactions.where(paid: report.paid) unless report.paid.nil?
        transactions = transactions.where(cost_center_id: report.params[:cost_center].select { |i| i != '' }) if report.params[:cost_center].present? && report.params[:cost_center].count != 1
        transactions = transactions.where(cost_center_id: nil) if !report.params[:cost_center].present? || report.params[:cost_center].count == 1

        create_response(transactions:)

        context.transactions = transactions

      end

      private

      def create_response(transactions:)
        result = []
        days = []
        report = context.context

        transactions.each do |transaction|
          days << transaction.due_date.to_date
        end

        days.uniq!

        days.each do |day|
          result << [day.strftime("%d/%m/%Y"), transactions.where(due_date: day).sum(:exchanged_amount_cents).to_f / 100]
        end
        context.result = result unless report.params[:order].present?
        context.result = result.sort_by! { |result| result[1] } if report.params[:order] == "asc"
        context.result = result.sort_by! { |result| -result[1] } if report.params[:order] == "desc"
      end
    end
  end
end
