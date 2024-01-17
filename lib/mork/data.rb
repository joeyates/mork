# frozen_string_literal: true

module Mork
  class Data
    attr_reader :rows

    def initialize(rows:)
      @rows = rows
    end
  end
end

