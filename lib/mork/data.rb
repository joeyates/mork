# frozen_string_literal: true

module Mork
  # The pure data extracted from a Mork file
  class Data
    attr_reader :rows
    attr_reader :tables

    def initialize(rows:, tables:)
      @rows = rows
      @tables = tables
    end
  end
end
