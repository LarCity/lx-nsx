# frozen_string_literal: true

spec = File.expand_path('../../spec', __dir__)
$LOAD_PATH.unshift(spec) unless $LOAD_PATH.include?(spec)

require 'rspec'
require 'aruba/cucumber'
require_relative '../../spec/spec_helper'

Before do |_scenario|
  # Implement code that will run before each scenario here
end

Around do |_scenario, block|
  # Implement code that will run around each scenario here
  # RSpec::Mocks.allow_message(Lx::Nsx::Utils, :env_config).with(%r{^spec/fixtures/\.*/ddns/active\.yml$}, env: 'test') do
  #   YAML.safe_load_file(File.expand_path('../fixtures/ddns/active.yml', __dir__))
  # end
  #
  RSpec::Mocks.with_temporary_scope do
    # allow(Lx::Nsx::Utils).to \
    #   receive(:env_config)
    #     .with(%r{^spec/fixtures/\.*/ddns/active\.ya?ml$}, env: 'test') do
    #       YAML.safe_load_file(File.expand_path('../fixtures/ddns/active.yml', __dir__))
    #     end
    Lx::Nsx::Utils.stub(:env_config).with(%r{^spec/fixtures/\.*/ddns/active\.ya?ml$}, env: 'test') do
      YAML.safe_load_file(File.expand_path('../fixtures/ddns/active.yml', __dir__))
    end
    # Run the scenario
    block.call
  end
end

After do |_scenario|
  # Implement code that will run after each scenario here
end
