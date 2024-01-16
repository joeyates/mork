# frozen_string_literal: true

module Mork
  # A meta table
  class MetaTable
    attr_reader :raw

    def initialize(raw:)
      @raw = raw
    end
  end
end
