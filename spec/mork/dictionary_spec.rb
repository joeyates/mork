# frozen_string_literal: true

require "mork/dictionary"

module Mork
  RSpec.describe Dictionary do
    subject { described_class.new(content: content) }

    let(:content) do
      [instance_double(Alias, key: "A", value: "a")]
    end

    describe "#to_h" do
      it "returns a Hash of aliases" do
        expect(subject.to_h).to eq({"A" => "a"})
      end
    end

    describe "#scope" do
      it "returns 'a'" do
        expect(subject.scope).to eq("a")
      end

      context "when the dictionary has a meta alias" do
        let(:content) { [instance_double(MetaAlias, scope: "foo")] }

        it "returns the meta alias's scope" do
          expect(subject.scope).to eq("foo")
        end
      end
    end
  end
end
