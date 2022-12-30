# frozen_string_literal: true

module Contacts
  module Searchable
    extend ActiveSupport::Concern

    included do
      include PgSearch::Model

      pg_search_scope(
        :search_by_q,
        against: %i[first_name last_name document_1 document_2 email phone_number],
        using: { tsearch: { prefix: true } },
        ignoring: :accents
      )
    end
  end
end
