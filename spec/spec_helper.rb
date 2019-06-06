ENV["RAILS_ENV"] ||= "test"

if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start "rails" do
    coverage_dir ENV["COVERAGE_DIR"] || "coverage"

    add_group "Controllers", "app/controllers"
    add_group "Models", "app/models"
    add_group "Mailers", "app/mailers"

    add_filter "/app/controllers"
    add_filter "/app/mailers"

    add_filter "/app/admin"
    add_filter "/app/channels"
    add_filter "/app/jobs"
    add_filter "/db/"
    add_filter "/spec/"
    add_filter "/lib/"
  end
end

require File.expand_path("config/environment")

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require "rspec/rails"
require "ffaker"

Dir["#{File.dirname(__FILE__)}/testing_support/*.rb"].each do |f|
  load File.expand_path(f)
end

RSpec.configure do |config|
  config.color = true
  config.fail_fast = ENV["FAIL_FAST"] || false
  config.fixture_path = File.join(__dir__, "fixtures")
  config.infer_spec_type_from_file_location!
  config.mock_with :rspec
  config.raise_errors_for_deprecations!

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, comment the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.around do |example|
    Timeout.timeout(30, &example)
  end
end
