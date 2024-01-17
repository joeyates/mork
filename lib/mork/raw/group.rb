# frozen_string_literal: true

require "mork/raw/row"

module Mork
  class Raw; end # rubocop:disable Lint/EmptyClass

  # A group of updates to the data
  class Raw::Group
    attr_reader :content

    def initialize(content:)
      @content = content
    end

    def rows
      content.filter { |c| c.is_a?(Raw::Row) }
    end
  end
end
