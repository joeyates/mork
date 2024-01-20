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
      action, namespace, id = resolve_id(dictionaries)
      Resolved::Row.new(
        action: action, namespace: namespace, id: id, cells: resolved_cells(dictionaries)
      )
    end

    private

    def raw_id_resolver
      @raw_id_resolver ||= Raw::Id.new(raw: raw_id)
    end

    def resolve_id(dictionaries)
      resolved_id = raw_id_resolver.resolve(dictionaries: dictionaries)
      action = resolved_id.action
      id = resolved_id.id
      namespace = resolved_id.namespace
      [action, namespace, id]
    end

    def resolved_cells(dictionaries)
      cells.map { |c| c.resolve(dictionaries: dictionaries) }
    end
  end
end
