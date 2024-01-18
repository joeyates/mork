# frozen_string_literal: true

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
      [resolved_namespace(dictionaries), id, resolved_rows(dictionaries)]
    end

    private

    def id
      id, _namespace = split_raw_id
      id
    end

    def raw_namespace
      @raw_namespace ||=
        begin
          _id, raw_namespace = split_raw_id
          raw_namespace
        end
    end

    def resolved_namespace(dictionaries)
      case
      when raw_namespace.nil?
        nil
      when raw_namespace.start_with?("^")
        value = raw_namespace[1..]
        dictionary = dictionaries.fetch("c")
        dictionary.fetch(value)
      else
        raw_namespace
      end
    end

    def resolved_rows(dictionaries)
      rows.map { |r| r.resolve(dictionaries: dictionaries) }
    end

    # rubocop:disable Lint/MixedRegexpCaptureTypes
    # Rubocop gives a false positive here
    RAW_ID_MATCH = /
    \A
    \{                 # The lexer captures the table delimiter
    (?<id>[0-9]+)      # Tables are numbered
    (
      :
      (?<raw_namespace>
        \^?            # The raw namespace may be a reference
        \S+            # The name is everything but trailing whitespace
      )
    )?                 # The namespace is optional
    /x.freeze
    # rubocop:enable Lint/MixedRegexpCaptureTypes

    def split_raw_id
      m = RAW_ID_MATCH.match(raw_id)
      [m[:id], m[:raw_namespace]]
    end
  end
end
