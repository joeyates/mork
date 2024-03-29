# frozen_string_literal: true

require "mork/raw/cell"

module Mork
  RSpec.describe Raw::Cell do
    subject { described_class.new(raw: raw) }

    let(:raw) { "raw" }

    describe "#raw" do
      it "returns the supplied value" do
        expect(subject.raw).to eq(raw)
      end
    end

    describe "#resolve" do
      let(:raw) { "^AA=42" }
      let(:dictionaries) { {"c" => dictionary_c, "a" => dictionary_a} }
      let(:dictionary_c) { {"AA" => "ciao"} }
      let(:dictionary_a) { {"Y" => "99"} }
      let(:result) { subject.resolve(dictionaries: dictionaries) }

      it "returns a Resolved::Cell" do
        expect(result).to be_a(Resolved::Cell)
      end

      it "returns the key" do
        expect(result.key).to eq("ciao")
      end

      it "returns the value" do
        expect(result.value).to eq("42")
      end

      context "when the value is a reference" do
        let(:raw) { "^AA^Y" }

        it "resolves the reference" do
          expect(result.value).to eq("99")
        end
      end
    end
  end
end
