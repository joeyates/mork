# frozen_string_literal: true

require "mork/alias"
require "mork/meta_alias"

module Mork
  # A key-value mapping with a namespace ("scope")
  class Dictionary
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
      @aliases ||= content.filter { |c| c.is_a?(Mork::Alias) }
    end

    def meta
      @meta ||= content.find { |c| c.is_a?(Mork::MetaAlias) }
    end
  end
end
