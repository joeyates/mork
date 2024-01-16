module Mork
  class Cell
    attr_reader :raw

    def initialize(raw:)
      @raw = raw
    end
  end
end
