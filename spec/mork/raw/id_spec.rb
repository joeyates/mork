# frozen_string_literal: true

require "mork/raw/id"

module Mork
  RSpec.describe Raw::Id do
    subject { described_class.new(raw: raw) }

    let(:raw) { "99:x" }

    describe "#resolve" do
      let(:result) { subject.resolve(dictionaries: {"c" => {"AA" => "hi"}}) }

      it "returns an Mork::Id" do
        expect(result).to be_a(Mork::Id)
      end

      it "sets the default action to :add" do
        expect(result.action).to eq(:add)
      end

      context "when the namespace is a reference" do
        let(:raw) { "99:^AA" }

        it "resolves the namespace" do
          expect(result.namespace).to eq("hi")
        end
      end

      context "when the action is 'delete'" do
        let(:raw) { "-99:x" }

        it "sets the action to :delete" do
          expect(result.action).to eq(:delete)
        end
      end
    end
  end
end
