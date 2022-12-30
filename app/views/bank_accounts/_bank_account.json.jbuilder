json.extract! bank_account, :id, :name, :account_type_cd, :balance_cents, :balance_currency, :initial_balance_cents, :initial_balance_currency, :created_at, :updated_at
json.url bank_account_url(bank_account, format: :json)
