# frozen_string_literal: true

module Mork
  # A cell in a row
  class Cell
    attr_reader :raw

    def initialize(raw:)
      @raw = raw
    end
  end
end
