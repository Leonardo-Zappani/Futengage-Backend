json.transaction do
  json.extract! transaction, :id, :due_date, :name, :description, :amount_cents,
                :amount_currency, :paid, :paid_at, :payment_type, :payment_method, :created_at, :updated_at, :bank_account_id, :transaction_type, :contact_id,
                :category_id, :document_number, :competency_date, :installment_type, :installment_number, :installment_total
end

json.meta do
  json.show transaction_url(transaction, format: :json)
end
