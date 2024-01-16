module Mork
  class MetaAlias
    attr_reader :raw

    def initialize(raw:)
      @raw = raw
    end

    def scope
      _from, to = raw.split("=")
      to
    end
  end
end
