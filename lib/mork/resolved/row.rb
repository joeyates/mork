# frozen_string_literal: true

module Mork
  class Resolved; end # rubocop:disable Lint/EmptyClass

  # A resolved Row
  class Resolved::Row
    attr_reader :action
    attr_reader :namespace
    attr_reader :id
    attr_reader :cells

    def initialize(action:, namespace:, id:, cells:)
      @action = action
      @namespace = namespace
      @id = id
      @cells = cells
    end

    def to_h
      cells.
        each.with_object({}) do |cell, acc|
        acc[cell.key] = cell.value
      end
    end
  end
end
