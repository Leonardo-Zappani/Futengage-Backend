# frozen_string_literal: true

module Page
  class PaginatorComponent < ApplicationComponent
    include Pagy::Frontend

    def initialize(paginator:)
      @paginator = paginator
      super
    end
  end
end
