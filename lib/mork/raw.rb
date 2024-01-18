# frozen_string_literal: true

require "mork/data"
require "mork/raw/dictionary"
require "mork/raw/row_resolver"
require "mork/raw/table_resolver"

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
      Data.new(
        rows: row_resolver.resolve(dictionaries: dictionaries),
        tables: table_resolver.resolve(dictionaries: dictionaries)
      )
    end

    private

    def raw_dictionaries
      @raw_dictionaries ||= values.filter { |v| v.is_a?(Raw::Dictionary) }
    end

    def row_resolver
      @row_resolver ||= Raw::RowResolver.new(values: values)
    end

    def table_resolver
      @table_resolver ||= Raw::TableResolver.new(values: values)
    end
  end
end
