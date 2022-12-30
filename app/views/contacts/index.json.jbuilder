# frozen_string_literal: true

json.array! @records, partial: 'contacts/contact', as: :contact
