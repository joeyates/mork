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
      let(:cells) { [instance_double(Raw::Cell, resolve: "resolved cell")] }
      let(:result) { subject.resolve(dictionaries: {"c" => {"AA" => "hi", "AB" => "X"}}) }

      it "returns a Resolved::Row" do
        expect(result).to be_a(Resolved::Row)
      end

      it "returns the action" do
        expect(result.action).to eq(:add)
      end

      it "returns the namespace" do
        expect(result.namespace).to eq("ciao")
      end

      it "returns the id" do
        expect(result.id).to eq("99")
      end

      it "returns the resolved cells" do
        expect(result.cells).to eq(["resolved cell"])
      end

      context "when the row namespace is a reference" do
        let(:raw_id) { "99:^AB" }

        it "returns the resolved namespace" do
          expect(result.namespace).to eq("X")
        end
      end
    end
  end
end
