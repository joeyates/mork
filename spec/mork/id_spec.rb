# frozen_string_literal: true

require "mork/id"

module Mork
  RSpec.describe Id do
    subject { described_class.new(action: action, namespace: namespace, id: id) }

    let(:action) { :add }
    let(:namespace) { "x" }
    let(:id) { "99" }

    it "has an action" do
      expect(subject.action).to eq(:add)
    end

    it "has a namespace" do
      expect(subject.namespace).to eq("x")
    end

    it "has an id" do
      expect(subject.id).to eq("99")
    end
  end
end
