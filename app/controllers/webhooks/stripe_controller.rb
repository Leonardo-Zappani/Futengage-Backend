# frozen_string_literal: true

module Webhooks
  class StripeController < Webhooks::ApplicationController
    before_action :set_endpoint_secret

    def create
      sig_header = request.env.fetch('HTTP_STRIPE_SIGNATURE')

      event = Stripe::Webhook.construct_event(
        request.body.read, sig_header, @endpoint_secret
      )

      # Handle the event
      case event.type
      when 'customer.subscription.updated', 'customer.subscription.deleted'
        subscription = event.data.object
        account = Account.find_by(processor_customer_id: subscription.customer)
        price = subscription.items.data[0].price

        account.update!(
          subscription_status: subscription.status,
          processor_plan_id: price.id,
          processor_plan_name: price.nickname
        )
      else
        Rails.logger.info("Unhandled event type: #{event.type}")
      end

      head :ok
    rescue JSON::ParserError => e
      Rails.logger.error(e)
      head :bad_request
    rescue Stripe::SignatureVerificationError => e
      Rails.logger.error(e)
      head :bad_request
    end

    private

    def set_endpoint_secret
      @endpoint_secret = Rails.application.credentials.dig(:stripe, :webhook_secret)
    end
  end
end
