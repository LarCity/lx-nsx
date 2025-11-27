# frozen_string_literal: true

spec = File.expand_path('../../spec', __dir__)
$LOAD_PATH.unshift(spec) unless $LOAD_PATH.include?(spec)

require 'rspec'
require 'aruba/cucumber'
require_relative '../../spec/spec_helper'

# TODO: Document a reference for this pattern of stubbing within a Before hook
Before do |_scenario|
  # Implement code that will run before each scenario here
end

Around do |_scenario, block|
  # TODO: Document a reference for this pattern of stubbing within an Around hook
  RSpec::Mocks.with_temporary_scope do
    # TODO: Is this stub doing anything? Don't think so. I believe the way this test suite
    #   is currently structured, the actual config file is being used directly and created
    #   ahead of time via Gherkin steps.
    Lx::Nsx::Utils.stub(:env_config).with(%r{^spec/fixtures/\.*/ddns/active\.ya?ml$}, env: 'test') do
      YAML.safe_load_file(File.expand_path('../fixtures/ddns/active.yml', __dir__))
    end
    # Run the scenario
    block.call
  end
end

# TODO: Document a reference for this pattern of stubbing within an After hook
After do |_scenario|
  # Implement code that will run after each scenario here
end
