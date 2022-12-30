# frozen_string_literal: true

module Page
  class HeaderComponent < ApplicationComponent
    renders_one  :search
    renders_many :actions

    def initialize(title:, subtitle: nil)
      @title = title
      @subtitle = subtitle
      super
    end
  end
end
