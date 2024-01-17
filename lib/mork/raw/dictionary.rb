# frozen_string_literal: true

require "mork/raw/alias"
require "mork/raw/meta_alias"

module Mork
  class Raw; end # rubocop:disable Lint/EmptyClass

  # A key-value mapping with a namespace ("scope")
  class Raw::Dictionary
    attr_reader :content

    def initialize(content:)
      @content = content
    end

    def to_h
      aliases.each.with_object({}) { |a, acc| acc[a.key] = a.value }
    end

    # a - "Atom" - the data
    # c - "Column" - the column name
    def scope
      meta&.scope || "a"
    end

    private

    def aliases
      @aliases ||= content.filter { |c| c.is_a?(Raw::Alias) }
    end

    def meta
      @meta ||= content.find { |c| c.is_a?(Raw::MetaAlias) }
    end
  end
end
