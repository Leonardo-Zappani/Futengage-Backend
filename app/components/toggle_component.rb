# frozen_string_literal: true

class ToggleComponent < ApplicationComponent
  def initialize(url:, method: :patch, enabled: false, params: {})
    super
    @url = url
    @method = method
    @enabled = enabled
    @params = params
  end
end
