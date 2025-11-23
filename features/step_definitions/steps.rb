# frozen_string_literal: true

require 'cucumber/rspec/doubles'

Given(/^(?:a|the) YAML config file named "([^"]*)" with:$/) do |file_name, file_content|
  RSpec::Mocks.with_temporary_scope do
    allow(File).to receive(:exist?).with(file_name).and_return(true)
    allow(Dir).to receive(:exist?).with(File.dirname(file_name)).and_return(true)
    allow(YAML).to receive(:load_file).with(file_name).and_return(YAML.safe_load(file_content))
    # allow(YAML).to receive(:load_file).with(file_name).and_return(file_content)
  end
end

When(/^I successfully run the ddns update command with a custom config file$/) do
  cmd_args = %w[--protocol=digitalocean --verbose --pretend]
  # Since we have a custom config file
  cmd_args += %w[--config spec/fixtures/lar_city/ddns/active.yml]
  # Run the command
  run `lx-nsx ddns update -- #{cmd_args.join(' ')}`
end

When(/^I successfully run the ddns update command$/) do
  run `lx-nsx ddns update -- --protocol=digitalocean --verbose --pretend`
end
