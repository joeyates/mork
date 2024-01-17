# frozen_string_literal: true

module Mork
  class Raw; end # rubocop:disable Lint/EmptyClass

  # A row of cells
  class Raw::Row
    attr_reader :raw_id
    attr_reader :cells

    def initialize(raw_id:, cells:)
      @raw_id = raw_id
      @cells = cells
    end

    def resolve(dictionaries:)
      cells.each.with_object({}) do |c, acc|
        key, value = c.resolve(dictionaries: dictionaries)
        acc[key] = value
      end
    end
  end
end
