# frozen_string_literal: true

require "mork/data"
require "mork/raw/row_resolver"
require "mork/raw/table_resolver"

module Mork
  class Raw; end # rubocop:disable Lint/EmptyClass

  # A group of updates to the data
  class Raw::Group
    attr_reader :values

    def initialize(values:)
      @values = values
    end

    def resolve(dictionaries:)
      Data.new(
        rows: row_resolver.resolve(dictionaries: dictionaries),
        tables: table_resolver.resolve(dictionaries: dictionaries)
      )
    end

    def row_resolver
      @row_resolver ||= Raw::RowResolver.new(values: values)
    end

    def table_resolver
      @table_resolver ||= Raw::TableResolver.new(values: values)
    end
  end
end
