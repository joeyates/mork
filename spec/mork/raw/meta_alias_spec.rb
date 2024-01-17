# frozen_string_literal: true

require "mork/raw/meta_alias"

module Mork
  RSpec.describe Raw::MetaAlias do
    subject { described_class.new(raw: "a=x") }

    describe "#scope" do
      it "is extracted from the supplied pair" do
        expect(subject.scope).to eq("x")
      end
    end
  end
end
