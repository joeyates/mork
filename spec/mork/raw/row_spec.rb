# frozen_string_literal: true

require "mork/raw/row"
require "mork/raw/cell"

module Mork
  RSpec.describe Raw::Row do
    subject { described_class.new(raw_id: raw_id, cells: cells) }

    let(:raw_id) { "99:ciao" }
    let(:cells) { "cells" }

    describe "#raw_id" do
      it "returns the supplied value" do
        expect(subject.raw_id).to eq(raw_id)
      end
    end

    describe "#cells" do
      it "returns the cells in the row" do
        expect(subject.cells).to eq("cells")
      end
    end

    describe "#resolve" do
      let(:cells) { [Raw::Cell.new(raw: "^AA=there")] }
      let(:result) { subject.resolve(dictionaries: {"c" => {"AA" => "hi", "AB" => "X"}}) }

      it "returns a namespace, id and Hash of columns and values" do
        expect(result).to eq(["ciao", "99", {"hi" => "there"}])
      end

      context "when the row namespace is a reference" do
        let(:raw_id) { "99:^AB" }

        it "returns a namespace, id and Hash of columns and values" do
          expect(result).to eq(["X", "99", {"hi" => "there"}])
        end
      end
    end
  end
end
