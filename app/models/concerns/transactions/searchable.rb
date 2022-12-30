# frozen_string_literal: true

module Transactions
  module Searchable
    extend ActiveSupport::Concern

    included do
      include PgSearch::Model

      pg_search_scope(
        :search_by_q,
        against: %i[name description],
        associated_against: {
          category: %i[name],
          cost_center: %i[name],
          contact: %i[first_name last_name]
        },
        using: { tsearch: { prefix: true } },
        ignoring: :accents
      )
    end
  end
end
