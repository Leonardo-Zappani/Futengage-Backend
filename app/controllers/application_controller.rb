class ApplicationController < ActionController::Base

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  include SetCurrent
  before_action :current_match
  before_action :list_match
  protected

  def configure_permitted_parameters
    user_params = %i[first_name last_name email password password_confirmation avatar]
    devise_parameter_sanitizer.permit(:sign_up, keys: user_params)
  end

end
