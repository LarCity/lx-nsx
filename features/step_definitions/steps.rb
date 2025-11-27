# frozen_string_literal: true

require 'cucumber/rspec/doubles'
require 'fileutils'
require 'lx/nsx/utils'

Given(/^(?:a|the) YAML config file named "([^"]*)" with:$/) do |file_name, file_content|
  RSpec::Mocks.with_temporary_scope do
    # Create the specified file in the spec/tmp directory - unless
    # an absolute path is given
    # TODO: Explore using a global temp directory for all tests
    #   and cleaning it up after the test suite runs - perhaps via
    #   Rake task or Cucumber hook. Alternatively, test the current
    #   implementation which creates files in spec/tmp upon restart
    #   of the test machine to ensure no leftover files exist.
    unless file_name.start_with?('/')
      target_spec_file = File.join(Lx::Nsx::Utils.spec_path(tmp: true), file_name)
      unless File.exist?(target_spec_file)
        FileUtils.mkdir_p(File.dirname(target_spec_file), verbose: true)
        File.write(target_spec_file, file_content)
      end
    end
  end
end

# TODO: This step is a draft and not used yet
When(/^I successfully run the ddns update command with a custom config file$/) do
  cmd_args = %w[--protocol=digitalocean --verbose --pretend]
  # Since we have a custom config file
  cmd_args += %w[--config=spec/fixtures/lar_city/ddns/active.yml]
  # Run the command
  `lx-nsx ddns update -- #{cmd_args.join(' ')}`
end

# TODO: This step is a draft and not used yet
When(/^I successfully run the ddns update command$/) do
  `lx-nsx ddns update -- --protocol=digitalocean --verbose --pretend`
end
