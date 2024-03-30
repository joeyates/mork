# frozen_string_literal: true

require "mork/resolved/id"

module Mork
  class Raw; end # rubocop:disable Lint/EmptyClass

  # A raw Mork ID
  class Raw::Id
    attr_reader :raw

    ACTIONS = {
      "-" => :delete,
      nil => :add
    }.freeze

    def initialize(raw:)
      @raw = raw
    end

    def resolve(dictionaries:)
      namespace = resolve_namespace(dictionaries)
      Resolved::Id.new(action: action, namespace: namespace, id: id)
    end

    private

    def action
      ACTIONS[parts["action"]]
    end

    def id
      parts["id"]
    end

    def raw_namespace
      parts["raw_namespace"]
    end

    def resolve_namespace(dictionaries)
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

    # rubocop:disable Lint/MixedRegexpCaptureTypes
    # Rubocop gives a false positive here
    RAW_ID_MATCH = /
    \A
    \{?                # The lexer captures the table delimiter
    (?<action>-)?      # The optional action can indicate deletion
    (?<id>[A-F0-9]+)   # Tables are numbered
    (
      :
      (?<raw_namespace>
        \^?            # The raw namespace may be a reference
        \S+            # The name is everything but trailing whitespace
      )
    )?                 # The namespace is optional
    /x.freeze
    # rubocop:enable Lint/MixedRegexpCaptureTypes

    def parts
      @parts ||= RAW_ID_MATCH.match(raw)
    end
  end
end
