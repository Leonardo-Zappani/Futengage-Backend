# frozen_string_literal: true

module Table
  class ItemComponent < ApplicationComponent
    renders_many :cols, 'Table::ColumnComponent'

    def initialize(item:, classes: '', link: nil, options: {})
      super
      @item = item
      @classes = classes
      @link = link
      @options = options
    end
  end
end
