# frozen_string_literal: true

module Mork
  # An alias indicating a Dictionary's scope
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
