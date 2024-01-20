# frozen_string_literal: true

require "mork/raw/group"
require "mork/raw/row"
require "mork/raw/table"

module Mork
  RSpec.describe Raw::Group do
    subject { described_class.new(values: values) }

    let(:values) { [row1, table1, dictionary1, "foo"] }
    let(:row1) { instance_double(Raw::Row, resolve: "resolved row") }
    let(:table1) do
      instance_double(Raw::Table, resolve: ["ns", "table_id", {"row_id" => "resolved row"}])
    end
    let(:dictionary1) { instance_double(Raw::Dictionary, scope: "c") }

    describe "#values" do
      it "returns the supplied value" do
        expect(subject.values).to eq(values)
      end
    end

    describe "#dictionaries" do
      let(:result) { subject.dictionaries }

      it "returns supplied dictionaries" do
        expect(result).to eq([dictionary1])
      end
    end

    describe "#resolve" do
      let(:dictionaries) { {} }
      let(:data) { subject.resolve(dictionaries: dictionaries) }

      it "returns a Data instance" do
        expect(data).to be_a(Data)
      end

      it "resolves rows" do
        expect(data.rows).to eq(["resolved row"])
      end

      it "resolves tables" do
        expect(data.tables).to eq({"ns" => {"table_id" => {"row_id" => "resolved row"}}})
      end
    end
  end
end
