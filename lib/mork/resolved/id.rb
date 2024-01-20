# frozen_string_literal: true

module Mork
  class Resolved; end # rubocop:disable Lint/EmptyClass

  # A resolved Mork Id
  class Resolved::Id
    attr_reader :action
    attr_reader :namespace
    attr_reader :id

    def initialize(action:, namespace:, id:)
      @action = action
      @namespace = namespace
      @id = id
    end
  end
end
