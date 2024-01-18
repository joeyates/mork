# frozen_string_literal: true

require "mork/raw/table"

module Mork
  class Raw; end # rubocop:disable Lint/EmptyClass

  # Resolves raw table data into clean data
  class Raw::TableResolver
    attr_reader :values

    def initialize(values:)
      @values = values
    end

    def resolve(dictionaries:)
      raw_tables.
        map { |t| t.resolve(dictionaries: dictionaries) }.
        each.with_object({}) do |(namespace, id, rows), acc|
          acc[namespace] ||= {}
          acc[namespace][id] = rows
        end
    end

    private

    def raw_tables
      @raw_tables ||= values.filter { |v| v.is_a?(Raw::Table) }
    end
  end
end
