# frozen_string_literal: true

require "mork/raw/table_resolver"

module Mork
  RSpec.describe Raw::TableResolver do
    subject { described_class.new(values: values) }

    let(:values) { [table1, "other"] }
    let(:table1) do
      instance_double(Raw::Table, resolve: ["ns", "table_id", {"row_id" => "resolved row"}])
    end
    let(:dictionaries) { "dictionaries" }
    let(:tables) { subject.resolve(dictionaries: dictionaries) }

    it "returns resolved tables" do
      expect(tables).to eq({"ns" => {"table_id" => {"row_id" => "resolved row"}}})
    end
  end
end
