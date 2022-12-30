# frozen_string_literal: true

class BillingPortalSessionsController < ApplicationController
  def create
    result = Billing::CreateBillingPortalSession.call(account: Current.account)
    redirect_to result.session.url, allow_other_host: true, status: :see_other
  end
end
