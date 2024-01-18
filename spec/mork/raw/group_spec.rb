# frozen_string_literal: true

require "mork/raw/group"

module Mork
  RSpec.describe Raw::Group do
    subject { described_class.new(values: values) }

    let(:values) { [row, "foo"] }
    let(:row) { Raw::Row.new(raw_id: "id", cells: []) }

    describe "#values" do
      it "returns the supplied value" do
        expect(subject.values).to eq(values)
      end
    end

    describe "#rows" do
      it "returns all rows in the supplied values" do
        expect(subject.rows).to eq([row])
      end
    end
  end
end
