# frozen_string_literal: true

module TabsHelper
  def active_tab?(value, param_name)
    value == params[param_name.to_sym]
  end
end
