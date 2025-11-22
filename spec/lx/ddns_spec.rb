# frozen_string_literal: true

RSpec.describe Lx::Nsx::Ddns do
  describe ".sync" do
    it "returns synchronization message" do
      expect(Lx::Nsx::Ddns.sync).to eq("Synchronizing DDNS records...")
    end
  end
end
