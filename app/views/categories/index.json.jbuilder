# frozen_string_literal: true

json.array! @records, partial: 'categories/category', as: :category
