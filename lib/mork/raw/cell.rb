# frozen_string_literal: true

module Mork
  class Raw; end # rubocop:disable Lint/EmptyClass

  # A cell in a row
  class Raw::Cell
    attr_reader :raw

    def initialize(raw:)
      @raw = raw
    end

    def resolve(dictionaries:)
      parse(dictionaries)
    end

    private

    PAIR_MATCH = /
    \A
    \^                       # Cell keys are always references
    (?<key>[89A-F][0-9A-F])  # Reference names are hex >= 80
    (?<value_type>[\^\=])    # Cell values can be references or direct values
    (?<value>.*)
    /x.freeze

    def parse(dictionaries)
      raw_key, value_type, raw_value = raw_parts
      key = resolve_value(raw_key, dictionaries["c"])
      value =
        if value_type == "^"
          resolve_value(raw_value, dictionaries["a"])
        else
          raw_value
        end
      [key, value]
    end

    def raw_parts
      m = PAIR_MATCH.match(raw)
      raw_key = m[:key]
      value_type = m[:value_type]
      raw_value = m[:value]
      [raw_key, value_type, raw_value]
    end

    def resolve_value(reference, dictionary)
      dictionary.fetch(reference)
    end
  end
end
