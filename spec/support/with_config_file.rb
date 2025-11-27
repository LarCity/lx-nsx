# frozen_string_literal: true

require 'lx/nsx/utils'

# This helper method creates a configuration file with the specified content
# in a temporary or specified location for testing purposes.
#
# Parameters:
# - file_name_or_path: The name of the file to create in the spec/tmp directory,
#   or an absolute path where the file should be created.
# - file_content: The content to write into the configuration file.
# - tmp: Boolean indicating whether to use the temporary spec path (default: true).
# - verbose: Boolean indicating whether to output verbose messages during file operations (default: false).
#
# Usage:
# with_config_file('config.yml', 'key: value') do |file_path|
#   # Use the created config file at file_path
# end
#
# Raises an error if the file cannot be created or found.
#
# TODO: Write a test for this helper method
def with_config_file(file_name_or_path, file_content, tmp: true, verbose: false)
  target_file =
    if file_name_or_path.to_s.start_with?('/')
      file_name_or_path
    else
      # TODO: Support non-spec paths via an optional parameter
      target_spec_file = File.join(Lx::Nsx::Utils.spec_path(tmp:), file_name_or_path)
      unless File.exist?(target_spec_file)
        FileUtils.mkdir_p(File.dirname(target_spec_file), verbose:)
        # The default behavior (offset: 0) overwrites existing files
        File.write(target_spec_file, file_content)
      end
      target_spec_file
    end

  raise "Config file not found: #{target_file}" unless File.exist?(target_file)

  yield target_file if block_given?
end
