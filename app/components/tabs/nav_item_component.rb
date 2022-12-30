# frozen_string_literal: true

class Tabs::NavItemComponent < ApplicationComponent
  def initialize(name:, url:, active:)
    @name = name
    @url = url
    @active = active
    super
  end

end
