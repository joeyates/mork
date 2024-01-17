# frozen_string_literal: true

require "mork/raw"

module Mork
  RSpec.describe Raw do
    subject { described_class.new(values: values) }

    let(:values) do
      [dictionary_c, dictionary_first_a, dictionary_second_a]
    end
    let(:dictionary_first_a) do
      instance_double(Raw::Dictionary, "a1", scope: "a", to_h: {"X" => "1"})
    end
    let(:dictionary_second_a) do
      instance_double(Raw::Dictionary, "a2", scope: "a", to_h: {"Y" => "2"})
    end
    let(:dictionary_c) do
      instance_double(Raw::Dictionary, "c", scope: "c", to_h: {"Z" => "3"})
    end

    describe "#dictionaries" do
      it "builds namespaced dictionaries" do
        expect(subject.dictionaries.keys.sort).to eq(%w[a c])
      end

      it "merges source dictionaries by namespace" do
        expect(subject.dictionaries["a"].to_h).to eq({"X" => "1", "Y" => "2"})
      end
    end

    describe "#data" do
      let(:values) do
        [row1, table1]
      end
      let(:row1) { instance_double(Raw::Row, resolve: "resolved row") }
      let(:table1) { instance_double(Raw::Table, resolve: ["ns", "id", ["resolved row"]]) }
      let(:data) { subject.data }

      it "returns a Data object" do
        expect(data).to be_a(Data)
      end

      it "returns resolved rows" do
        expect(data.rows).to eq(["resolved row"])
      end

      it "returns resolved tables" do
        expect(data.tables).to eq({"ns" => {"id" => ["resolved row"]}})
      end
    end
  end
end
