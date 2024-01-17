# frozen_string_literal: true

require "mork/table"

module Mork
  RSpec.describe Table do
    subject { described_class.new(raw_id: "raw_id", content: content) }

    let(:content) { [row, "foo"] }
    let(:row) { Raw::Row.new(raw_id: "id", cells: []) }

    describe "#raw_id" do
      it "returns the supplied value" do
        expect(subject.raw_id).to eq("raw_id")
      end
    end

    describe "#content" do
      it "returns the supplied value" do
        expect(subject.content).to eq(content)
      end
    end

    describe "#rows" do
      it "returns all rows in the supplied content" do
        expect(subject.rows).to eq([row])
      end
    end
  end
end
