# frozen_string_literal: true

module Lx
  module Nsx
    RSpec.describe Ddns do
      let(:command) { described_class.new }
      let(:command_args) { {} }
      let(:config_file) { 'fake_company/ddns/active.yml' }
      let(:config_content) do
        <<~YAML
          - domain: larcity.tech
            content: ho
            type: A
            ttl: 3600
          - domain: larcity.org
            content: staging.ho
            type: A
            ttl: 3600
          - domain: larcity.org
            content: auth.staging
            type: A
            ttl: 3600
        YAML
      end

      subject(:operation) { command.invoke(:update, [], **command_args) }

      describe '#update' do
        let(:command_args) do
          {
            config: config_file,
            protocol: 'digitalocean',
            pretend: true,
            verbose: true,
          }
        end

        before do
          allow(Dir).to receive(:exist?).with(File.dirname(config_file)).and_return(true)
          allow(File).to receive(:exist?).with(config_file).and_return(true)
          allow(Utils).to receive(:env_config).with(config_file, env: 'test') do
            YAML.safe_load(config_content, symbolize_names: true)
          end
        end

        it 'loads the configuration and synchronizes DDNS records' do
          # with_config_file(config_file, config_content, tmp: true, verbose: true) do |file_path|
          #   expect { operation }.not_to raise_error
          # end
          expect { operation }.not_to raise_error
        end
      end
    end
  end
end
