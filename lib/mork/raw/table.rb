# frozen_string_literal: true

require "mork/raw/id"
require "mork/raw/row"

module Mork
  class Raw; end # rubocop:disable Lint/EmptyClass

  # A table of rows
  class Raw::Table
    attr_reader :raw_id
    attr_reader :content

    def initialize(raw_id:, content:)
      @raw_id = raw_id
      @content = content
    end

    def rows
      content.filter { |c| c.is_a?(Raw::Row) }
    end

    def resolve(dictionaries:)
      [resolved_namespace(dictionaries), resolved_id(dictionaries), resolved_rows(dictionaries)]
    end

    private

    def raw_id_resolver
      @raw_id_resolver ||= Raw::Id.new(raw: raw_id)
    end

    def raw_id_resolved(dictionaries)
      @raw_id_resolved ||= raw_id_resolver.resolve(dictionaries: dictionaries)
    end

    def resolved_id(dictionaries)
      raw_id_resolved(dictionaries)[1]
    end

    def resolved_namespace(dictionaries)
      raw_id_resolved(dictionaries).first
    end

    def resolved_rows(dictionaries)
      rows.each.with_object({}) do |r, acc|
        _namespace, id, row = r.resolve(dictionaries: dictionaries)
        acc[id] = row
      end
    end
  end
end
