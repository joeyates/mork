# frozen_string_literal: true

require "mork/data"
require "mork/raw/dictionary"
require "mork/raw/table_resolver"

module Mork
  class Raw; end # rubocop:disable Lint/EmptyClass

  # A group of updates to the data
  class Raw::Group
    attr_reader :values

    def initialize(values:)
      @values = values
    end

    def dictionaries
      @dictionaries ||= values.filter { |r| r.is_a?(Raw::Dictionary) }
    end

    def resolve(dictionaries:)
      Data.new(
        rows: resolved_rows(dictionaries),
        tables: table_resolver.resolve(dictionaries: dictionaries)
      )
    end

    private

    def raw_rows
      @raw_rows ||= values.filter { |v| v.is_a?(Raw::Row) }
    end

    def resolved_rows(dictionaries)
      raw_rows.map { |r| r.resolve(dictionaries: dictionaries) }
    end

    def table_resolver
      @table_resolver ||= Raw::TableResolver.new(values: values)
    end
  end
end
