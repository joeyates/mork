# frozen_string_literal: true

require "mork/raw/alias"

module Mork
  RSpec.describe Raw::Alias do
    subject { described_class.new(key: "my_key", value: "my_value") }

    describe "#key" do
      it "is the supplied key" do
        expect(subject.key).to eq("my_key")
      end
    end

    describe "#value" do
      it "is the supplied value" do
        expect(subject.value).to eq("my_value")
      end
    end
  end
end
