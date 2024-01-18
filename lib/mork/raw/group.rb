# frozen_string_literal: true

require "mork/raw/row"

module Mork
  class Raw; end # rubocop:disable Lint/EmptyClass

  # A group of updates to the data
  class Raw::Group
    attr_reader :values

    def initialize(values:)
      @values = values
    end

    def rows
      values.filter { |c| c.is_a?(Raw::Row) }
    end
  end
end
