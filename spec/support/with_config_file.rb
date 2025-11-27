# frozen_string_literal: true

require 'lx/nsx/utils'

def with_config_file(file_name_or_path, file_content, tmp: true, verbose: false)
  target_file =
    if file_name_or_path.to_s.start_with?('/')
      file_name_or_path
    else
      target_spec_file = File.join(Lx::Nsx::Utils.spec_path(tmp:), file_name_or_path)
      unless File.exist?(target_spec_file)
        FileUtils.mkdir_p(File.dirname(target_spec_file), verbose:)
        File.write(target_spec_file, file_content)
      end
      target_spec_file
    end

  raise "Config file not found: #{target_file}" unless File.exist?(target_file)

  yield target_file if block_given?
end
