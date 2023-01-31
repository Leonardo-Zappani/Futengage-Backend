class ApplicationController < ActionController::Base

  
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  skip_before_action :verify_authenticity_token 


  protected

  def configure_permitted_parameters
    user_params = %i[first_name last_name email password password_confirmation avatar role]
    devise_parameter_sanitizer.permit(:sign_up, keys: user_params)
  end

end
