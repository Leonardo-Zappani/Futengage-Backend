# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  include DeviceDetector
  include SetLocale
  include SetTimeZone
  include SetCurrent
  include Pagy::Backend
  include Sortable

  rescue_from CanCan::AccessDenied do |_exception|
    respond_to do |format|
      alert = t('shared.you_are_not_authorized_to_access_this_page')
      format.json { head :forbidden }
      format.html { redirect_to root_path, alert: }
      format.turbo_stream { flash.now.alert = alert }
    end
  end

  protected

  def audited_user
    return t('shared.guest') unless user_signed_in?

    current_user
  end

  def after_sign_in_path_for(resource)
    if resource.admin?
      rails_admin_path || super
    else
      super
    end
  end

  def configure_permitted_parameters
    user_params = %i[first_name last_name preferred_language time_zone terms_of_service]

    if params[:invite].present?
      devise_parameter_sanitizer.permit(:sign_up, keys: user_params << :invite)
    else
      account_params = [account_attributes: [:default_currency, :processor_plan_id, { company_attributes: :name }]]
      devise_parameter_sanitizer.permit(:sign_up, keys: user_params + account_params)
    end
  end

  def ensure_frame_response
    return unless Rails.env.development?
    return if request.format.json?

    redirect_to root_path unless turbo_frame_request?
  end

  def ensure_account_is_active
    return if Current.account.active? || Current.account.trial_period?

    result = Subscriptions::CreateCheckoutPortalSession.call(account: Current.account)
    redirect_to result.session.url, allow_other_host: true, status: :see_other
  end
end
