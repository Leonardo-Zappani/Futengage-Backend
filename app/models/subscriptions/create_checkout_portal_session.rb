module Subscriptions
  class CreateCheckoutPortalSession < ApplicationInteractor
    def call
      context.session = Stripe::Checkout::Session.create(
        success_url: ENV.fetch('CHECKOUT_PORTAL_SUCCESS_URL', 'http://localhost:3000/checkout_portal_sessions/success?session_id={CHECKOUT_SESSION_ID}'),
        cancel_url: ENV.fetch('CHECKOUT_PORTAL_CANCEL_URL', 'http://localhost:3000'),
        mode: 'subscription',
        customer: context.account.processor_customer_id,
        line_items: [{
          quantity: 1,
          price: context.processor_plan_id
        }]
      )
    end
  end
end
