# frozen_string_literal: true

require "mork/meta_alias"

module Mork
  RSpec.describe MetaAlias do
    subject { described_class.new(raw: "a=x") }

    describe "#scope" do
      it "is extracted from the supplied pair" do
        expect(subject.scope).to eq("x")
      end
    end
  end
end
