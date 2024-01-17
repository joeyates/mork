# frozen_string_literal: true

module Mork
  class Raw; end # rubocop:disable Lint/EmptyClass

  # A key-value alias pair
  class Raw::Alias
    attr_reader :key
    attr_reader :value

    def initialize(key:, value:)
      @key = key
      @value = value
    end
  end
end
