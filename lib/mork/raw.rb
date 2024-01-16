require "mork/dictionary"

module Mork
  class Raw
    attr_reader :values

    def initialize(values:)
      @values = values
    end

    # build a Hash of scopes (usually "a" and "c")
    # each value being a Hash of key-value entries
    def dictionaries
      @dictionaries ||=
        begin
          raw_dictionaries.each.with_object({}) do |d, scopes|
            scope = d.scope
            scopes[scope] ||= {}
            scopes[scope].merge!(d.to_h)
          end
        end
    end

    private

    def raw_dictionaries
      @raw_dictionaries ||= values.filter { |v| v.is_a?(Mork::Dictionary) }
    end
  end
end
