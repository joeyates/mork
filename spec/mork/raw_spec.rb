require "mork/raw"

module Mork
  RSpec.describe Raw do
    subject { described_class.new(values: values) }

    let(:values) do
      [dictionary_c, dictionary_a1, dictionary_a2]
    end
    let(:dictionary_a1) do
      instance_double(Dictionary, "a1", scope: "a", to_h: {"X" => "1"})
    end
    let(:dictionary_a2) do
      instance_double(Dictionary, "a2", scope: "a", to_h: {"Y" => "2"})
    end
    let(:dictionary_c) do
      instance_double(Dictionary, "c", scope: "c", to_h: {"Z" => "3"})
    end

    it "builds namespaced dictionaries" do
      dictionaries = subject.dictionaries
      expect(subject.dictionaries.keys.sort).to eq(%w[a c])
    end

    it "merges source dictionaries by namespace" do
      expect(subject.dictionaries["a"].to_h).to eq({"X" => "1", "Y" => "2"})
    end
  end
end
