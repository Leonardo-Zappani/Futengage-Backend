# frozen_string_literal: true

module SetCurrent
  extend ActiveSupport::Concern

  included do |base|
    set_current_tenant_through_filter

    before_action :set_request_details if base < ActionController::Base
    helper_method :current_account
  end

  def set_request_details
    Current.request_id = request.uuid
    Current.user_agent = request.user_agent
    Current.ip_address = request.ip
    Current.user = current_user
    Current.time = DateTime.current
    Current.date = Date.current
    Current.account = find_current_account || fallback_account
    set_current_tenant(Current.account)
    set_sentry_user
  end

  def current_account
    Current.account
  end

  private

  def find_current_account
    return unless user_signed_in?

    current_user.account
  end

  def fallback_account
    return unless user_signed_in?

    current_user.accounts.first
  end

  def set_sentry_user
    return unless user_signed_in?

    Sentry.set_user(
      id: Current.user.id,
      email: Current.user.email,
      username: Current.user.name,
      ip_address: Current.ip_address
    )
  end
end
