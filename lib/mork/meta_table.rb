module Mork
  class MetaTable
    attr_reader :raw

    def initialize(raw:)
      @raw = raw
    end
  end
end
