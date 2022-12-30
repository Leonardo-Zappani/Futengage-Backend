# frozen_string_literal: true

module CalculationsHelper
  def calculate_percentage(float_one, float_two)
    CalculationsHelper.calculate_percentage(float_one, float_two)
  end

  def self.calculate_percentage(float_one, float_two)
    return 0.0 if float_two.zero? || float_one.zero?

    (float_one / float_two) * 100.to_f
  end
end
