require_relative "boot"

require "rails/all"

require "elasticsearch/rails/instrumentation"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OpenLibrary
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.action_mailer.default_url_options = { host: "localhost", port: 3000 }

    config.active_job.queue_adapter = :inline

    config.active_storage.queues.analysis = :low_priority
    config.active_storage.queues.purge = :low_priority

    CREDENTIALS = Rails.application.credentials

    # Mailer
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.default_options = {
      from: CREDENTIALS.dig(:mailer, :from),
      reply_to: CREDENTIALS.dig(:mailer, :reply_to),
      subject: CREDENTIALS.dig(:mailer, :subject),
    }
    config.action_mailer.smtp_settings = {
      address: CREDENTIALS.dig(:mailer, :address),
      port: CREDENTIALS.dig(:mailer, :port),
      domain: CREDENTIALS.dig(:mailer, :domain),
      user_name: CREDENTIALS.dig(:mailer, :username),
      password: CREDENTIALS.dig(:mailer, :password),
      authentication: CREDENTIALS.dig(:mailer, :authentication),
      enable_starttls_auto: CREDENTIALS.dig(:mailer, :enable_starttls_auto) == "true", # rubocop:disable Metrics/LineLength
    }
    config.action_mailer.default_url_options = {
      host: CREDENTIALS.dig(:mailer, :url_host) || CREDENTIALS.url_host, # rubocop:disable Metrics/LineLength
      only_path: CREDENTIALS.dig(:mailer, :url_host).present? || CREDENTIALS.url_host.present?, # rubocop:disable Metrics/LineLength
    }
  end
end
