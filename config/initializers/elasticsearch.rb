ENV["ELASTICSEARCH_URL"] ||= Rails.application.credentials.elasticsearch_url

OkComputer::Registry.register "elasticsearch",
                              OkComputer::ElasticsearchCheck.new(ENV["ELASTICSEARCH_URL"]) # rubocop:disable Metrics/LineLength
