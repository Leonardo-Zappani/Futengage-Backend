json.items @records, partial: 'transactions/transaction', as: :transaction
json.meta do
  json.index transactions_url(format: :json)
end
