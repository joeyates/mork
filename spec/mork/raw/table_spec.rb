# frozen_string_literal: true

require "mork/raw/table"

module Mork
  RSpec.describe Raw::Table do
    subject { described_class.new(raw_id: raw_id, content: content) }

    let(:raw_id) { "{1:^80" }
    let(:content) { [row, "foo"] }
    let(:row) { instance_double(Raw::Row, raw_id: "id", resolve: "resolved row") }

    describe "#raw_id" do
      it "returns the supplied value" do
        expect(subject.raw_id).to eq(raw_id)
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

    describe "#resolve" do
      let(:result) { subject.resolve(dictionaries: dictionaries) }
      let(:dictionaries) { {"a" => {"80" => "X"}} }

      it "returns the namespace" do
        expect(result).to match(["X", anything, anything])
      end

      it "returns the id" do
        expect(result).to match([anything, "1", anything])
      end

      it "returns the rows" do
        expect(result).to match([anything, anything, ["resolved row"]])
      end
    end
  end
end
