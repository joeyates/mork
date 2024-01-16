require "mork/meta_table"

module Mork
  RSpec.describe MetaTable do
    subject { described_class.new(raw: "raw") }

    describe "#raw" do
      it "returns the supplied value" do
        expect(subject.raw).to eq("raw")
      end
    end
  end
end

