# frozen_string_literal: true

require "mork/raw/id"

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
      [resolved_namespace(dictionaries), resolved_id(dictionaries), resolved_cells(dictionaries)]
    end

    private

    def raw_id_resolver
      @raw_id_resolver ||= Raw::Id.new(raw: raw_id)
    end

    def raw_id_resolved(dictionaries)
      @raw_id_resolved ||= raw_id_resolver.resolve(dictionaries: dictionaries)
    end

    def resolved_id(dictionaries)
      raw_id_resolved(dictionaries)[1]
    end

    def resolved_namespace(dictionaries)
      raw_id_resolved(dictionaries).first
    end

    def resolved_cells(dictionaries)
      cells.each.with_object({}) do |c, acc|
        key, value = c.resolve(dictionaries: dictionaries)
        acc[key] = value
      end
    end
  end
end
