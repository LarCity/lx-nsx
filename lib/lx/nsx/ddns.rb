# frozen_string_literal: true

require 'erb'
require 'lar_city/cli/core_cmd'
require 'lx/ddclient'
require 'yaml'

module Lx
  module Nsx
    class Ddns < ::LarCity::CLI::CoreCmd
      attr_reader :config_path

      Utils.setup_config_paths

      option :config,
             type: :string,
             aliases: '-c',
             default: Utils.base_path('lib/config/ddns/active.yml'),
             desc: 'Path to DDNS configuration files',
             required: true
      option :protocol,
             type: :string,
             aliases: '-p',
             enum: %w[digitalocean],
             required: true
      desc 'update', 'Synchronize DDNS records from a YAML configuration file'
      def update
        ap options
        say_debug "Loading DDNS configuration for environment: #{detected_environment}"
        set_config_resource options[:config]

        # Load active records from config file
        data = load_config
        ap data if verbose?

        say_info 'Synchronizing DDNS records...'

        access_token = Utils.credentials.dig(options[:protocol].to_sym, :api_token)
        data.each do |record|
          say_info "Would update record: #{record.inspect}" if pretend?

          domain, content = record.values_at(:domain, :content)
          context = Ddclient::ConfigContext.new
          context.protocol = options[:protocol]
          context.hostname = domain
          context.login = [content, domain].join('.')
          context.password = access_token
          # TODO: Require that the record ID be specified in the config file OR
          #   implement logic to look up existing record ID based on domain/name/type
          # context.record_id = record[:record_id]
          template_content = File.read(Utils.base_path('lib/lx/ddclient/config.conf.erb'))
          config_content = ERB.new(template_content).result(context.get_binding)
          # TODO: Refactor with_config_file to a Utils module class method
          with_config_file("lar_city/ddclient/#{context.login}.conf", config_content, tmp: true) do |config_file_path|
            say_info "Using ddclient config file at: #{config_file_path}"
          end
        end
      end

      no_commands do
        private

        # TODO: Support iterating over multiple possible config locations
        #   (e.g., system-wide, user-specific, project-specific, working directory
        #   and home directory)
        def set_config_resource(dir_or_file_path)
          # Get directory from provided path
          path = dir_or_file_path.match?(/\.ya?ml$/) ? File.dirname(dir_or_file_path) : dir_or_file_path
          # Set config path based on whether absolute or relative path is provided
          @config_path = Utils.infer_resource_path path
        end

        def load_config(key: :active)
          say_debug "Loading DDNS config file for key: #{key} at path: #{config_path}"
          raise ArgumentError, 'DDNS config path is not set' if config_path.blank?

          config_file_for_key = File.join(config_path, "#{key}.yml")
          Utils.env_config(config_file_for_key, env: detected_environment)
        end
      end
    end
  end
end
