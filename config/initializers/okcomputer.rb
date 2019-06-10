OkComputer.mount_at = "health"

STATS_AUTH = Rails.application.credentials.dig(:health_check, :auth)
OkComputer.require_authentication(*STATS_AUTH.to_s.split(":")) if STATS_AUTH

OkComputer::OkComputerController.class_eval do
  force_ssl except: :index if ENV["STATS_SSL"] == true
end

# rubocop:disable Metrics/LineLength
ELASTICSEARCH_URL = Rails.application.credentials.dig(:elasticsearch_url)
OkComputer::Registry.register "elasticsearch",
                              OkComputer::ElasticsearchCheck.new(ELASTICSEARCH_URL)

OkComputer::Registry.register "mailer",
                              OkComputer::ActionMailerCheck.new(ActionMailer::Base)
# rubocop:enable Metrics/LineLength

OkComputer.make_optional %w(mailer)
