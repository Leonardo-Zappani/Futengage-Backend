# frozen_string_literal: true

module Transactions
  class MonthNavigatorComponent < ApplicationComponent
    def initialize(prev_url:, current_url:, next_url:, current_month:, turbo_frame:)
      @prev_url = prev_url
      @current_url = current_url
      @next_url = next_url
      @current_month = current_month
      @turbo_frame = turbo_frame
      super
    end
  end
end

