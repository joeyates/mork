# frozen_string_literal: true

require "mork/raw/table"

module Mork
  RSpec.describe Raw::Table do
    subject { described_class.new(raw_id: raw_id, values: values) }

    let(:raw_id) { "{1:^80" }
    let(:values) { [row, "foo"] }
    let(:row) do
      instance_double(Raw::Row, raw_id: "id", resolve: "resolved row")
    end

    describe "#raw_id" do
      it "returns the supplied value" do
        expect(subject.raw_id).to eq(raw_id)
      end
    end

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

    describe "#resolve" do
      let(:result) { subject.resolve(dictionaries: dictionaries) }
      let(:dictionaries) { {"c" => {"80" => "X"}} }

      it "returns a Resolved::Table" do
        expect(result).to be_a(Resolved::Table)
      end

      it "returns the namespace" do
        expect(result.namespace).to eq("X")
      end

      it "returns the id" do
        expect(result.id).to eq("1")
      end

      it "returns the rows" do
        expect(result.rows).to eq(["resolved row"])
      end
    end
  end
end
