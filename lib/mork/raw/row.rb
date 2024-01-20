# frozen_string_literal: true

require "mork/raw/id"
require "mork/resolved/row"

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
      resolved_id = raw_id_resolver.resolve(dictionaries: dictionaries)
      Resolved::Row.new(
        action: resolved_id.action,
        namespace: resolved_id.namespace,
        id: resolved_id.id,
        cells: resolved_cells(dictionaries)
      )
    end

    private

    def raw_id_resolver
      @raw_id_resolver ||= Raw::Id.new(raw: raw_id)
    end

    def resolved_cells(dictionaries)
      cells.map { |c| c.resolve(dictionaries: dictionaries) }
    end
  end
end
