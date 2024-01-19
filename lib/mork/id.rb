# frozen_string_literal: true

module Mork
  # A resolved Mork Id
  class Id
    attr_reader :action
    attr_reader :namespace
    attr_reader :id

    def initialize(action:, namespace:, id:)
      @action = action
      @namespace = namespace
      @id = id
    end
  end
end
