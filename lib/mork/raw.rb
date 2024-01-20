# frozen_string_literal: true

require "mork/data"
require "mork/raw/dictionary"
require "mork/raw/group"
require "mork/raw/table_resolver"

module Mork
  # Raw data returned by the Parser
  class Raw
    attr_reader :values

    def initialize(values:)
      @values = values
    end

    # build a Hash of scopes (usually "a" and "c")
    # each value being a Hash of key-value entries
    def dictionaries
      @dictionaries ||=
        raw_dictionaries.each.with_object({}) do |d, scopes|
          scope = d.scope
          scopes[scope] ||= {}
          scopes[scope].merge!(d.to_h)
        end
    end

    def data
      Data.new(
        rows: resolved_rows(dictionaries),
        tables: resolved_tables(dictionaries)
      )
    end

    private

    def raw_dictionaries
      @raw_dictionaries ||= top_level_dictionaries + group_dictionaries
    end

    def top_level_dictionaries
      @top_level_dictionaries ||= values.filter { |v| v.is_a?(Raw::Dictionary) }
    end

    def group_dictionaries
      @group_dictionaries ||= raw_groups.flat_map(&:dictionaries)
    end

    def raw_groups
      @raw_groups ||= values.filter { |v| v.is_a?(Raw::Group) }
    end

    def resolved_groups(dictionaries)
      @resolved_groups ||=
        raw_groups.
        map { |g| g.resolve(dictionaries: dictionaries) }
    end

    ####################
    # rows

    def raw_rows
      @raw_rows ||= values.filter { |v| v.is_a?(Raw::Row) }
    end

    def resolved_rows(dictionaries)
      all =
        raw_rows.map { |r| r.resolve(dictionaries: dictionaries) } +
        resolved_groups(dictionaries).map(&:rows)
      all.
        group_by(&:namespace).
        each.
        with_object({}) do |(namespace, rows), acc_rows|
          acc_rows[namespace] = merge_namespace_rows(acc_rows[namespace] || {}, rows)
        end
    end

    def merge_namespace_rows(all_rows, group_rows)
      group_rows.each.with_object(all_rows) do |rows, acc_rows|
        rows.each do |row|
          case row.action
          when :add
            acc_rows[row.id] = row.to_h
          when :delete
            acc_rows.delete(row.id)
          end
        end
      end
    end

    ####################
    # tables

    def resolved_tables(dictionaries)
      all_tables = table_resolver.resolve(dictionaries: dictionaries)
      resolved_groups(dictionaries).
        each.
        with_object(all_tables) do |group, acc_tables|
          merge_group_tables(acc_tables, group.tables)
        end
    end

    def merge_group_tables(all_tables, group_tables)
      group_tables.
        each.
        with_object(all_tables) do |(namespace, namespace_tables), acc_tables|
          acc_namespace_tables = acc_tables[namespace] ||= {}
          merge_tables(acc_namespace_tables, namespace_tables)
        end
    end

    def merge_tables(into, from)
      from.
        each.
        with_object(into) do |(namespace, update_rows), acc|
          rows = acc[namespace] || {}
          rows.merge!(update_rows)
        end
    end

    def table_resolver
      @table_resolver ||= Raw::TableResolver.new(values: values)
    end
  end
end
