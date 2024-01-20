# frozen_string_literal: true

require "mork/data"
require "mork/raw/dictionary"

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
      {
        rows: resolved_rows(dictionaries),
        tables: resolved_tables(dictionaries)
      }
    end

    private

    def raw_rows
      @raw_rows ||= values.filter { |v| v.is_a?(Raw::Row) }
    end

    def raw_tables
      @raw_tables ||= values.filter { |v| v.is_a?(Raw::Table) }
    end

    def resolved_rows(dictionaries)
      raw_rows.map { |r| r.resolve(dictionaries: dictionaries) }
    end

    def resolved_tables(dictionaries)
      raw_tables.map { |t| t.resolve(dictionaries: dictionaries) }
    end
  end
end
