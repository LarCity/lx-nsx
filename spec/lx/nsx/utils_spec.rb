# frozen_string_literal: true

module Lx
  module Nsx
    RSpec.describe Utils do
      describe '.base_path' do
        let(:expected_path) { Dir.pwd }

        it 'returns the correct base path' do
          expect(described_class.base_path).to eq(expected_path)
        end
      end

      describe '.credentials' do
        subject(:creds) { described_class.credentials }

        let(:credentials_path) { described_class.base_path('config/credentials.yml.erb') }
        let(:credentials_content) do
          <<~YML
            ---
            shared:
              openai:
                api_key: <%= ENV['OPENAI_API_KEY'] || 'default_shared_key' %>
            development:
              digitalocean:
                api_key: <%= ENV['DEV_API_KEY'] || 'default_dev_key' %>
            production:
              digitalocean:
                api_key: <%= ENV['PROD_API_KEY'] || 'default_prod_key' %>
          YML
        end

        before do
          allow(File).to receive(:read).with(credentials_path).and_return(credentials_content)
        end

        context 'when no environment variables are set' do
          around do |example|
            with_modified_env('OPENAI_API_KEY' => nil, 'DEV_API_KEY' => nil, 'PROD_API_KEY' => nil) do
              example.run
            end
          end

          before do
            allow(described_class).to receive(:detected_environment).and_return('development')
          end

          it 'loads default shared credentials' do
            expect(creds).to include(openai: { api_key: 'default_shared_key' })
          end

          it 'loads default development environment credentials' do
            expect(creds).to include(digitalocean: { api_key: 'default_dev_key' })
          end
        end

        context 'when environment variables are set' do
          around do |example|
            with_modified_env(
              'OPENAI_API_KEY' => 'env_shared_key',
              'DEV_API_KEY' => 'env_dev_key',
              'PROD_API_KEY' => 'env_prod_key'
            ) do
              example.run
            end
          end

          before do
            allow(described_class).to receive(:detected_environment).and_return('production')
          end

          it 'loads env-specific shared credentials' do
            expect(creds).to include(openai: { api_key: 'env_shared_key' })
          end

          it 'loads production environment credentials' do
            expect(creds).to include(digitalocean: { api_key: 'env_prod_key' })
          end
        end
      end

      describe '.detected_environment' do
        context 'when no environment variables are set' do
          around do |example|
            with_modified_env('RAILS_ENV' => nil, 'RUBY_ENV' => nil) do
              example.run
            end
          end

          it { expect(described_class.detected_environment).to eq('development') }
        end

        context 'when environment variables are set' do
          let(:rails_env) { 'production' }
          let(:ruby_env) { 'staging' }

          around do |example|
            with_modified_env('RAILS_ENV' => rails_env, 'RUBY_ENV' => ruby_env) do
              example.run
            end
          end

          it 'prioritizes RAILS_ENV over RUBY_ENV' do
            expect(described_class.detected_environment).to eq(rails_env)
          end

          context 'and RAILS_ENV is not set' do
            let(:rails_env) { nil }

            it 'returns RUBY_ENV' do
              expect(described_class.detected_environment).to eq(ruby_env)
            end
          end
        end
      end

      describe '.env_config' do
        let(:example_config_path) { described_class.base_path('lib/config/ddns/active.example.yml') }
        let(:example_template_config_path) { described_class.base_path('lib/config/ddns/active.example.yml.erb') }

        around do |example|
          with_modified_env('RAILS_ENV' => nil, 'RUBY_ENV' => 'test') { example.run }
        end

        context 'when template is false' do
          subject(:config) do
            described_class.env_config(example_config_path, template: false)
          end

          it { expect(config.size).to eq(5) }

          context 'with shared records' do
            it { should include('content' => 'alpha', 'domain' => 'larcity.dev', 'type' => 'A', 'ttl' => 3600) }
            it { should include('content' => 'beta', 'domain' => 'larcity.tech', 'type' => 'A', 'ttl' => 3600) }
          end

          context 'with test environment records' do
            it { should include('content' => 'staging', 'domain' => 'fake.app', 'type' => 'A', 'ttl' => 3600) }
            it { should include('content' => 'production', 'domain' => 'fake.app', 'type' => 'A', 'ttl' => 3600) }
            it { should include('content' => 'mail', 'domain' => 'fake.app', 'type' => 'MX', 'priority' => 10, 'ttl' => 3600) }
          end
        end

        context 'when template is true' do
          subject(:config) do
            described_class.env_config(example_template_config_path, template: true)
          end

          around do |example|
            with_modified_env(
              'TEST_DEV_DOMAIN' => 'mock.dev',
              'TEST_TECH_DOMAIN' => 'mock.tech',
              'TEST_FAKE_DOMAIN' => 'fake.biz'
            ) do
              example.run
            end
          end

          it { expect(config.size).to eq(4) }

          context 'with shared records' do
            it { should include('content' => 'alpha', 'domain' => 'mock.dev', 'type' => 'A', 'ttl' => 3600) }
            it { should include('content' => 'beta', 'domain' => 'mock.tech', 'type' => 'A', 'ttl' => 3600) }
          end

          context 'with test environment records' do
            it { should include('content' => 'staging', 'domain' => 'fake.biz', 'type' => 'A', 'ttl' => 3600) }
            it { should include('content' => 'mail', 'domain' => 'fake.biz', 'type' => 'MX', 'priority' => 10, 'ttl' => 3600) }
          end
        end
      end
    end
  end
end
