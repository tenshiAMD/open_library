module SidekiqAddOns
  def flushdb
    Sidekiq.redis(&:flushdb)
  end
end
Sidekiq.send(:extend, SidekiqAddOns) unless Sidekiq.respond_to?(:flushdb)

##
# Configuration
##

REDIS_URL = ENV["REDIS_URL"] || Rails.application.credentials.redis_url

opts = {}
opts[:url] = REDIS_URL if REDIS_URL.present?

if opts.key?(:url)
  Sidekiq.configure_server do |config|
    config.redis = opts
  end

  Sidekiq.configure_client do |config|
    config.redis = opts
  end

  ActiveJob::Base.queue_adapter = :sidekiq unless Rails.env.test?
end

Sidekiq.default_worker_options = {
  unique: :until_executing,
  unique_args: ->(args) { args.first.except("job_id") },
}

##
# Logger
##
begin
  require "yell"
  yell_config_file = Rails.root.join("config", "yell-sidekiq.yml")
  logger = Yell.new("log/sidekiq.log")
  logger = Yell.load!(yell_config_file) if yell_config_file.file?
  Sidekiq::Logging.logger = logger
# rubocop:disable Lint/HandleExceptions
rescue LoadError
  # Do nothing
end
# rubocop:enable Lint/HandleExceptions
