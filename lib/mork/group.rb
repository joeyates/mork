require "mork/row"

module Mork
  class Group
    attr_reader :content

    def initialize(content:)
      @content = content
    end

    def rows
      content.filter { |c| c.is_a?(Row) }
    end
  end
end
