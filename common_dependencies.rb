group :development, :test do
  gem "brakeman", require: false

  gem "overcommit"

  gem "guard"
  gem "guard-spring"
  gem "guard-rspec", require: false

  gem "byebug"
  gem "better_errors"
  gem "binding_of_caller"

  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "spring-commands-rspec"

  # gem 'marginalia'

  gem "rspec-rails"
  gem "rspec-activejob"
  gem "rspec_junit_formatter"

  gem "fuubar"
end

group :development, :test do
  gem "codeclimate-test-reporter", require: false
  gem "simplecov", require: false

  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-junit-formatter"
  gem "inch", require: false
  gem "scss_lint", require: false
  gem "scss_lint_reporter_checkstyle", require: false
  gem "slim_lint", require: false
  gem "coffeelint", require: false
  gem "guard-rubocop", require: false

  gem "knapsack_pro"
  gem "faker"
  gem "ffaker"

  gem "letter_opener"
  gem "letter_opener_web"
end

group :test do
  gem "rails-controller-testing"
  gem "database_cleaner"

  gem "factory_bot_rails"
  gem "mocha"
  gem "assert_difference"
  gem "json-schema"

  gem "shoulda-matchers", "~> 3.0"
  gem "shoulda-callback-matchers"

  # Assets test
  gem "teaspoon-mocha"
  gem "selenium-webdriver"
  gem "magic_lamp"
end
