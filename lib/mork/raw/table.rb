# frozen_string_literal: true

require "mork/raw/id"
require "mork/raw/row"

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
      _action, namespace, id = resolve_id(dictionaries)
      [namespace, id, resolved_rows(dictionaries)]
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

    def resolved_rows(dictionaries)
      rows.each.with_object({}) do |r, acc|
        _namespace, id, row = r.resolve(dictionaries: dictionaries)
        acc[id] = row
      end
    end
  end
end
