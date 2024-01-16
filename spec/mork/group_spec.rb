require "mork/group"

module Mork
  RSpec.describe Group do
    subject { described_class.new(content: content) }

    let(:content) { [row, "foo"] }
    let(:row) { Row.new(raw_id: "id", cells: []) }

    describe "#content" do
      it "returns the supplied value" do
        expect(subject.content).to eq(content)
      end
    end

    describe "#rows" do
      it "It returns all rows in the supplied content" do
        expect(subject.rows).to eq([row])
      end
    end
  end
end

