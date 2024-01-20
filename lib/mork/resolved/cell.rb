# frozen_string_literal: true

module Mork
  class Resolved; end # rubocop:disable Lint/EmptyClass

  # A resolved Cell
  class Resolved::Cell
    attr_reader :key
    attr_reader :value

    def initialize(key:, value:)
      @key = key
      @value = value
    end
  end
end
