# frozen_string_literal: true

module Mork
  # A key-value alias pair
  class Alias
    attr_reader :key
    attr_reader :value

    def initialize(key:, value:)
      @key = key
      @value = value
    end
  end
end
