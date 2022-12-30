# frozen_string_literal: true

class CheckoutPortalSessionsController < ApplicationController
  def new
    @month_plans = Stripe::Plan.list({ interval: :month }).data.sort_by(&:amount)
    @year_plans  = Stripe::Plan.list({ interval: :year }).data.sort_by(&:amount)
  end

  def create
    result = Subscriptions::CreateCheckoutPortalSession.call(
      account: Current.account,
      processor_plan_id: checkout_session_params[:processor_plan_id]
    )
    redirect_to result.session.url, allow_other_host: true, status: :see_other
  end

  def success
    # session = Stripe::Checkout::Session.retrieve(params[:session_id])
    redirect_to root_path, notice: t('.success')
  end

  def checkout_session_params
    params.require(:checkout_session).permit(:processor_plan_id)
  end
end
