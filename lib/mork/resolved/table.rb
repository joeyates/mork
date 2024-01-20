# frozen_string_literal: true

module Mork
  class Resolved; end # rubocop:disable Lint/EmptyClass

  # A resolved Table
  class Resolved::Table
    attr_reader :action
    attr_reader :namespace
    attr_reader :id
    attr_reader :rows

    def initialize(action:, namespace:, id:, rows:)
      @action = action
      @namespace = namespace
      @id = id
      @rows = rows
    end
  end
end
