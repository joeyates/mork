module Mork
  class Row
    attr_reader :raw_id
    attr_reader :cells

    def initialize(raw_id:, cells:)
      @raw_id = raw_id
      @cells = cells
    end
  end
end
