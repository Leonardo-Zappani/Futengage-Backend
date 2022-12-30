# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = 'https://a528d55387ca485c9d19a294db7e56d3@o4504406116139008.ingest.sentry.io/4504406118301696'
  config.breadcrumbs_logger = %i[active_support_logger http_logger]
  config.environment = Rails.env
  config.logger = Sentry::Logger.new($stdout) if Rails.env.production?

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  # config.traces_sample_rate = 1.0
  # # or
  # config.traces_sampler = lambda do |_context|
  #   true
  # end
end
