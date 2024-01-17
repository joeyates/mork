# frozen_string_literal: true

require "mork/raw/row"

module Mork
  # A table of rows
  class Table
    attr_reader :raw_id
    attr_reader :content

    def initialize(raw_id:, content:)
      @raw_id = raw_id
      @content = content
    end

    def rows
      content.filter { |c| c.is_a?(Raw::Row) }
    end
  end
end
