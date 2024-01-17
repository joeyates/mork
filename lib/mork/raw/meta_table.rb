# frozen_string_literal: true

module Mork
  class Raw; end # rubocop:disable Lint/EmptyClass

  # A meta table
  class Raw::MetaTable
    attr_reader :raw

    def initialize(raw:)
      @raw = raw
    end
  end
end
