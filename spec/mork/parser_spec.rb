require "mork/parser"

module Mork
  RSpec.describe Parser do
    describe "#parse" do
      let(:mork_pathname) { "spec/fixtures/Foo.msf" }
      let(:content) { File.read(mork_pathname) }
      let(:result) { subject.parse(content) }

      it "returns raw parsed data" do
        expect(result).to be_a(Raw)
      end

      it "extracts dictionaries" do
        dictionaries = result.values.filter { |r| r.is_a?(Dictionary) }

        expect(dictionaries.count).to eq(5)
      end

      it "loads dictionary meta aliases" do
        dictionary_1 = result.values.find { |r| r.is_a?(Dictionary) }

        expect(dictionary_1.scope).to eq("c")
      end

      it "loads dictionary aliases" do
        dictionary_1 = result.values.find { |r| r.is_a?(Dictionary) }

        expect(dictionary_1.to_h["BC"]).to eq("dateReceived")
      end

      it "extracts groups" do
        groups = result.values.filter { |r| r.is_a?(Group) }

        expect(groups.count).to eq(2)
      end

      it "loads group rows" do
        group_1 = result.values.find { |r| r.is_a?(Group) }

        expect(group_1.rows.count).to eq(1)
      end

      it "extracts rows" do
        rows = result.values.filter { |r| r.is_a?(Row) }

        expect(rows.count).to eq(2)
      end

      it "loads row raw_ids" do
        row_1 = result.values.find { |r| r.is_a?(Row) }

        expect(row_1.raw_id).to eq("3:m")
      end

      it "extracts tables" do
        tables = result.values.filter { |r| r.is_a?(Table) }

        expect(tables.count).to eq(4)
      end

      it "loads table ids" do
        table_1 = result.values.find { |r| r.is_a?(Table) }

        expect(table_1.raw_id).to eq("{1:^80 ")
      end
    end
  end
end
