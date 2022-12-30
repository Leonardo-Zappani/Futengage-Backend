# frozen_string_literal: true

module Table
  class TableComponent < ApplicationComponent
    renders_one :header, 'Table::HeaderComponent'
    renders_one :body, 'Table::BodyComponent'

    def initialize(classes: '')
      super
      @classes = classes
    end
  end
end
