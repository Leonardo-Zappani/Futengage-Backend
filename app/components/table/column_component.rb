# frozen_string_literal: true

module Table
  class ColumnComponent < ApplicationComponent
    def initialize(classes: '')
      super
      @classes = classes
    end
  end
end
