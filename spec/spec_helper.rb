ENV["YOKUNAI_ENV"] ||= "test"

require "rack/test"
require "watashi"

def app
  Watashi::Application.new(
    route_map: Watashi::ROUTES,
    base_dir: Watashi::BASE_DIR
  )
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include Rack::Test::Methods, type: :request

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = "spec/examples.txt"
  config.disable_monkey_patching!
  config.warnings = true
  config.profile_examples =  5
  config.order = :random

  if config.files_to_run.one?
    config.default_formatter = "doc"
  end

  Kernel.srand config.seed

  config.before(:suite) do
    # call the app, just so we know it's booted and the config is populated,
    # hooks have run, etc.
    app
  end
end
