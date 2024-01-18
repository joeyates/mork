# frozen_string_literal: true

require "mork/raw/row_resolver"

module Mork
  RSpec.describe Raw::RowResolver do
    subject { described_class.new(values: values) }

    let(:values) { [row1, "other"] }
    let(:row1) { instance_double(Raw::Row, resolve: ["row_namespace", "row_id", "resolved row"]) }
    let(:dictionaries) { "dictionaries" }
    let(:rows) { subject.resolve(dictionaries: dictionaries) }

    it "returns resolved rows" do
      expect(rows).to eq({"row_namespace" => {"row_id" => "resolved row"}})
    end
  end
end
