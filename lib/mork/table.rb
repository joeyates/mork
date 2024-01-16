require "mork/row"

module Mork
  class Table
    attr_reader :raw_id
    attr_reader :content

    def initialize(raw_id:, content:)
      @raw_id = raw_id
      @content = content
    end

    def rows
      content.filter { |c| c.is_a?(Row) }
    end
  end
end
