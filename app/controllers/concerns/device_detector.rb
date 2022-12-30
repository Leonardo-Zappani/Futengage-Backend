# frozen_string_literal: true

module DeviceDetector
  extend ActiveSupport::Concern

  included do
    helper Turbo::Native::Navigation

    before_action :set_variant
  end

  def set_variant
    browser = Browser.new(request.user_agent)
    if browser.mobile?
      request.variant = :phone
    elsif browser.tablet?
      request.variant = :tablet
    end
  end
end
