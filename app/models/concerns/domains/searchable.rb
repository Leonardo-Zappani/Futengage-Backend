# frozen_string_literal: true

module Domains
  module Searchable
    extend ActiveSupport::Concern

    included do
      include PgSearch::Model

      pg_search_scope(
        :search_by_q,
        against: %i[name description],
        using: { tsearch: { prefix: true } },
        ignoring: :accents
      )
    end
  end
end
