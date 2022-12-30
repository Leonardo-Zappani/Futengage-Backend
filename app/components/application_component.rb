# frozen_string_literal: true

class ApplicationComponent < ViewComponent::Base
  include Turbo::FramesHelper
  include Heroicon::Engine.helpers
end
