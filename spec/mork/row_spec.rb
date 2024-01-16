# frozen_string_literal: true

require "mork/row"

module Mork
  RSpec.describe Row do
    subject { described_class.new(raw_id: "raw_id", cells: "cells") }

    describe "#raw_id" do
      it "returns the supplied value" do
        expect(subject.raw_id).to eq("raw_id")
      end
    end

    describe "#cells" do
      it "returns the cells in the row" do
        expect(subject.cells).to eq("cells")
      end
    end
  end
end
