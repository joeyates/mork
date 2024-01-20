# frozen_string_literal: true

require "mork/raw"
require "mork/raw/row"
require "mork/raw/table"

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
    let(:dictionary1) do
      instance_double(Raw::Dictionary, "dictionary1", scope: "a", to_h: {"from_group" => "yep"})
    end

    describe "#dictionaries" do
      it "builds namespaced dictionaries" do
        expect(subject.dictionaries.keys.sort).to eq(%w[a c])
      end

      it "merges source dictionaries by namespace" do
        expect(subject.dictionaries["a"].to_h).to eq({"X" => "1", "Y" => "2"})
      end

      context "when there are groups" do
        let(:values) do
          [dictionary_c, dictionary_first_a, dictionary_second_a, group1]
        end
        let(:group1) do
          instance_double(Raw::Group, "dictionaries group1", dictionaries: [dictionary1])
        end

        it "merges group dictionaries" do
          expect(subject.dictionaries["a"].to_h["from_group"]).to eq("yep")
        end
      end
    end

    describe "#data" do
      let(:values) { [row1, table1] }
      let(:row1) { instance_double(Raw::Row, resolve: resolved_row1) }
      let(:resolved_row1) do
        instance_double(
          Resolved::Row, "resolved row1",
          namespace: "row_namespace", action: :add, id: "row_id",
          to_h: "cell data"
        )
      end
      let(:table1) do
        instance_double(Raw::Table, resolve: resolved_table1)
      end
      let(:resolved_table1) do
        instance_double(
          Resolved::Table, "resolved table",
          namespace: "ns", action: :add, id: "table_id",
          rows: [resolved_table_row1]
        )
      end
      let(:resolved_table_row1) do
        instance_double(
          Resolved::Row, "resolved table row1",
          namespace: "row_namespace", action: :add, id: "row_id",
          to_h: "table row cell data"
        )
      end
      let(:data) { subject.data }

      it "returns a Data object" do
        expect(data).to be_a(Data)
      end

      it "returns resolved rows" do
        expect(data.rows).to eq({"row_namespace" => {"row_id" => "cell data"}})
      end

      it "returns resolved tables" do
        expect(data.tables).to eq({"ns" => {"table_id" => {"row_id" => "table row cell data"}}})
      end

      context "when there are groups" do
        let(:values) { [row1, table1, group1] }
        let(:group1) do
          instance_double(
            Raw::Group, "data group1",
            resolve: group_data,
            dictionaries: [dictionary1]
          )
        end
        let(:group_data) do
          {
            rows: [resolved_group_row],
            tables: [resolved_group_table]
          }
        end
        let(:resolved_group_row) do
          instance_double(
            Resolved::Row, "resolved group row",
            namespace: "row_namespace", action: :add,
            id: "group_row_id", to_h: "group row cell data"
          )
        end
        let(:resolved_group_table) do
          instance_double(
            Resolved::Table, "resolved group table",
            namespace: "ns", action: :add,
            id: "table_id",
            rows: [resolved_group_table_row]
          )
        end
        let(:resolved_group_table_row) do
          instance_double(
            Resolved::Row, "resolved group table row",
            namespace: "row_namespace", action: :add,
            id: "group_table_row_id", to_h: "group table row cell data"
          )
        end
        let(:expected_tables) do
          {
            "ns" => {
              "table_id" => {
                "row_id" => "table row cell data",
                "group_table_row_id" => "group table row cell data"
              }
            }
          }
        end

        it "merges in group rows" do
          expected = {
            "row_namespace" => {"row_id" => "cell data", "group_row_id" => "group row cell data"}
          }
          expect(data.rows).to eq(expected)
        end

        it "merges in group tables" do
          expect(data.tables).to eq(expected_tables)
        end
      end
    end
  end
end
