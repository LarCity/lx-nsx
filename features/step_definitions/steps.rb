# frozen_string_literal: true

require 'cucumber/rspec/doubles'
require 'fileutils'
require 'lx/nsx/utils'

Given(/^(?:a|the) YAML config file named "([^"]*)" with:$/) do |file_name, _file_content|
  RSpec::Mocks.with_temporary_scope do
    # allow(File).to receive(:exist?).with(file_name).and_return(true)
    # allow(Dir).to receive(:exist?).with(File.dirname(file_name)).and_return(true)
    unless file_name.start_with?('/')
      target_spec_file = File.join(Lx::Nsx::Utils.spec_path, file_name)
      unless File.exist?(target_spec_file)
        FileUtils.mkdir_p(File.dirname(target_spec_file), verbose: true)
        FileUtils.touch(target_spec_file, verbose: true)
        File.write(target_spec_file, _file_content)
      end
    end
  end
  #
  # %w[bin exe].each do |rel_path|
  #   RSpec::Mocks.allow_message(File, :exist?).with(File.join(Dir.pwd, rel_path)).and_call_original
  #   RSpec::Mocks.allow_message(Dir, :exist?).with(File.join(Dir.pwd, rel_path)).and_call_original
  # end
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
