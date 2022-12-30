# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Procfy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    # config.eager_load_paths << Rails.root.join('lib')
    config.assets.css_compressor = nil
    config.assets.debug = false

    # Permitted locales available for the application
    config.i18n.available_locales = %i[pt-BR en]
    config.i18n.default_locale = :'pt-BR'

    # Session store configuration
    config.session_store :cookie_store, key: "__procfy_#{Rails.env}", expire_after: 14.days

    # View components configurations
    config.view_component.generate_stimulus_controller = true
    config.view_component.generate.sidecar = true
    config.generators.template_engine = :haml

    # Active job configurations
    config.active_job.queue_adapter = :sidekiq

    # Active storage configurations
    # Store uploaded files on the local file system (see config/storage.yml for options).
    config.active_storage.service                   = :amazon
    config.active_storage.replace_on_assign_to_many = false
    config.active_storage.variant_processor         = :mini_magick
    config.active_storage.queues.analysis           = :active_storage_analysis
    config.active_storage.queues.purge              = :active_storage_purge

    # test configurations
    # config.active_record.verify_foreign_keys_for_fixtures = false

    # Action Mailer Default Config
    config.action_mailer.delivery_method = :mailgun
    config.action_mailer.mailgun_settings = {
      api_key: Rails.application.credentials.dig(:mailgun, :api_key),
      domain: 'mg.procfy.io'
    }
  end
end
