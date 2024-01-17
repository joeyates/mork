# frozen_string_literal: true

require "mork/data"
require "mork/raw/dictionary"
require "mork/raw/row"
require "mork/raw/table"

module Mork
  # Raw data returned by the Parser
  class Raw
    attr_reader :values

    def initialize(values:)
      @values = values
    end

    # build a Hash of scopes (usually "a" and "c")
    # each value being a Hash of key-value entries
    def dictionaries
      @dictionaries ||=
        raw_dictionaries.each.with_object({}) do |d, scopes|
          scope = d.scope
          scopes[scope] ||= {}
          scopes[scope].merge!(d.to_h)
        end
    end

    def data
      Data.new(rows: resolved_rows, tables: resolved_tables)
    end

    private

    def raw_dictionaries
      @raw_dictionaries ||= values.filter { |v| v.is_a?(Raw::Dictionary) }
    end

    def raw_rows
      @raw_rows ||= values.filter { |v| v.is_a?(Raw::Row) }
    end

    def raw_tables
      @raw_tables ||= values.filter { |v| v.is_a?(Raw::Table) }
    end

    def resolved_rows
      raw_rows.map { |r| r.resolve(dictionaries: dictionaries) }
    end

    def resolved_tables
      raw_tables.
      map { |t| t.resolve(dictionaries: dictionaries) }.
      each.with_object({}) do |(namespace, id, rows), acc|
        acc[namespace] ||= {}
        acc[namespace][id] = rows
      end
    end
  end
end
