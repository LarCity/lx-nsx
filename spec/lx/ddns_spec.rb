# frozen_string_literal: true

module Lx
  module Nsx
    RSpec.describe Ddns do
      describe '.update' do
        it 'returns synchronization message' do
          expect(Lx::Nsx::Ddns.sync).to eq('Synchronizing DDNS records...')
        end
      end

      describe '.config' do
        let(:default_key) { :active }
        let(:custom_path) { Lx::Nsx::Utils.base_path 'spec/fixtures/ddns' }
        let(:custom_key) { :retired }

        before do
          allow(YAML).to receive(:load_file).and_call_original
        end

        it 'loads configuration from the default key' do
          described_class.config(path: custom_path)
          expect(YAML).to have_received(:load_file).with(File.join(custom_path, "#{default_key}.yml"))
        end

        it 'loads configuration from a path and a supported key' do
          described_class.config(path: custom_path, key: custom_key)
          expect(YAML).to have_received(:load_file).with(File.join(custom_path, "#{custom_key}.yml"))
        end
      end
    end
  end
end
