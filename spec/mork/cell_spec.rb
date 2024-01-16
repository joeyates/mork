require "mork/cell"

module Mork
  RSpec.describe Cell do
    subject { described_class.new(raw: raw) }

    let(:raw) { "raw" }

    describe "#raw" do
      it "returns the supplied value" do
        expect(subject.raw).to eq(raw)
      end
    end
  end
end

