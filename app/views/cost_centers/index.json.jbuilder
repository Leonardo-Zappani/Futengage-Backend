# frozen_string_literal: true

json.array! @records, partial: 'cost_centers/cost_center', as: :cost_center
