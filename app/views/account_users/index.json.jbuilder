# frozen_string_literal: true

json.array! @records, partial: 'account_users/account_user', as: :account_user
