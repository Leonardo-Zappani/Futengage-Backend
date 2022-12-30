module Billing
  class CreateBillingPortalSession < ApplicationInteractor
    def call
      context.session = Stripe::BillingPortal::Session.create(
        customer: context.account.processor_customer_id,
        return_url: ENV.fetch('BILLING_PORTAL_RETURN_URL', 'http://localhost:3000')
      )
    end
  end
end
