# frozen_string_literal: true

require "mork/data"
require "mork/raw/dictionary"
require "mork/raw/group"

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
      raw_groups.
        map { |g| g.resolve(dictionaries: dictionaries) }
    end

    ####################
    # rows

    def raw_rows
      @raw_rows ||= values.filter { |v| v.is_a?(Raw::Row) }
    end

    def raw_tables
      @raw_tables ||= values.filter { |v| v.is_a?(Raw::Table) }
    end

    def unmerged_rows(dictionaries)
      top_level_rows = raw_rows.map { |r| r.resolve(dictionaries: dictionaries) }
      group_rows =
        resolved_groups(dictionaries).
        map { |g| g[:rows] }.
        flatten
      (top_level_rows + group_rows).group_by(&:namespace)
    end

    def resolved_rows(dictionaries)
      unmerged_rows(dictionaries).
        each.with_object({}) do |(namespace, rows), acc|
          acc[namespace] = reduce_rows(rows)
        end
    end

    def reduce_rows(rows)
      rows.each.with_object({}) do |row, acc|
        case row.action
        when :add
          acc[row.id] = row.to_h
        when :delete
          acc.delete(row.id)
        end
      end
    end

    ####################
    # tables

    def resolved_tables(dictionaries)
      unmerged = unmerged_tables(dictionaries)
      merged = merge_tables(unmerged)
      reduce_tables(merged)
    end

    def reduce_tables(tables)
      tables.
        each.with_object({}) do |(namespace, namespace_tables), acc1|
          acc1[namespace] =
            namespace_tables.each.with_object({}) do |(id, rows), acc2|
              acc2[id] = reduce_rows(rows)
            end
        end
    end

    def merge_tables(tables)
      tables.
        each.with_object({}) do |(namespace, namespace_tables), acc|
          merged = merge_namespace_tables(namespace_tables)
          acc[namespace] = merged if merged.any?
        end
    end

    def unmerged_tables(dictionaries)
      top_level_tables = unmerged_resolved_tables(dictionaries)
      group_tables =
        resolved_groups(dictionaries).
        map { |g| g[:tables] }.
        flatten
      (top_level_tables + group_tables).group_by(&:namespace)
    end

    def merge_namespace_tables(tables)
      tables.each.with_object({}) do |table, acc|
        case table.action
        when :add
          acc[table.id] ||= []
          acc[table.id] += table.rows
        when :delete
          acc.delete(table.id)
        end
      end
    end

    def unmerged_resolved_tables(dictionaries)
      raw_tables.map { |t| t.resolve(dictionaries: dictionaries) }
    end
  end
end
