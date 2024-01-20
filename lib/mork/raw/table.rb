# frozen_string_literal: true

require "mork/raw/id"
require "mork/raw/row"
require "mork/resolved/table"

module Mork
  class Raw; end # rubocop:disable Lint/EmptyClass

  # A table of rows
  class Raw::Table
    attr_reader :raw_id
    attr_reader :values

    def initialize(raw_id:, values:)
      @raw_id = raw_id
      @values = values
    end

    def rows
      values.filter { |c| c.is_a?(Raw::Row) }
    end

    def resolve(dictionaries:)
      resolved_id = resolve_id(dictionaries)
      Resolved::Table.new(
        action: resolved_id.action, namespace: resolved_id.namespace, id: resolved_id.id,
        rows: resolved_rows(dictionaries)
      )
    end

    private

    def raw_id_resolver
      @raw_id_resolver ||= Raw::Id.new(raw: raw_id)
    end

    def resolve_id(dictionaries)
      raw_id_resolver.resolve(dictionaries: dictionaries)
    end

    def resolved_rows(dictionaries)
      rows.map { |r| r.resolve(dictionaries: dictionaries) }
    end
  end
end
