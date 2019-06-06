require "active_job/test_helper"
require "rspec/active_job"

RSpec.configure do |config|
  config.include(ActiveJob::TestHelper)
  config.include(RSpec::ActiveJob)

  config.before(:each) do
    ActiveJob::Base.queue_adapter = :test
  end

  # clean out the queue after each spec
  config.after(:each) do
    ActiveJob::Base.queue_adapter.enqueued_jobs = []
    ActiveJob::Base.queue_adapter.performed_jobs = []
  end
end
