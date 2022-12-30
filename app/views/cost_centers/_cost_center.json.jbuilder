# frozen_string_literal: true

json.extract! cost_center, :id, :name, :description, :created_at, :updated_at
json.url cost_center_url(cost_center, format: :json)
