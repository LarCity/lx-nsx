require "bundler/setup"

ENV['RUBY_ENV'] ||= 'test'

require "dotenv"
require_relative "../lib/lx/nsx/utils"

# TODO: Move this logic to an initializer context elsewhere
prioritized_env_files = %W[.env.#{Lx::Nsx::Utils.detected_environment}.local .env.#{Lx::Nsx::Utils.detected_environment} .env]
Dotenv.load(*prioritized_env_files)

require "lx/nsx"
require "support/with_modified_env"

# Requires files in spec/support and its subdirectories
Dir[File.join(__dir__, 'support', '**', '*.rb')].sort.each {|file| require file }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
