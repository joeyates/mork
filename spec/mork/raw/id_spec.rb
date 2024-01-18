# frozen_string_literal: true

require "mork/raw/id"

module Mork
  RSpec.describe Raw::Id do
    subject { described_class.new(raw: raw) }

    let(:raw) { "99:x" }

    describe "#resolve" do
      let(:result) { subject.resolve(dictionaries: {"c" => {"AA" => "hi"}}) }

      it "returns a namespace and id" do
        expect(result).to eq(%w[x 99])
      end

      context "when the namespace is a reference" do
        let(:raw) { "99:^AA" }

        it "returns a namespace and id" do
          expect(result).to eq(%w[hi 99])
        end
      end
    end
  end
end
