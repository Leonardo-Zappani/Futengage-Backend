# frozen_string_literal: true

class TurboDrawerComponent < ApplicationComponent
  def initialize(title:)
    super
    @title = title
  end
end
