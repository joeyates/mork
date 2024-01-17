# frozen_string_literal: true

module Mork
  class Raw; end # rubocop:disable Lint/EmptyClass

  # An alias indicating a Dictionary's scope
  class Raw::MetaAlias
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
