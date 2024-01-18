# frozen_string_literal: true

require "mork/raw/row"

module Mork
  class Raw; end # rubocop:disable Lint/EmptyClass

  # Resolves raw row data into clean data
  class Raw::RowResolver
    attr_reader :values

    def initialize(values:)
      @values = values
    end

    def resolve(dictionaries:)
      raw_rows.
        each.
        with_object({}) do |r, acc|
          namespace, id, row = r.resolve(dictionaries: dictionaries)
          acc[namespace] ||= {}
          acc[namespace][id] = row
        end
    end

    private

    def raw_rows
      @raw_rows ||= values.filter { |v| v.is_a?(Raw::Row) }
    end
  end
end
