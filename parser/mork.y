# mork
# LALR parser generator for Mork files
#
# Generate Ruby parser
# $ racc parser/mork.y --output-file lib/mork/parser.rb
class Mork::Parser

rule
  start: magic top_level { result = Mork::Raw.new(values: val[1]) }
  top_level: { result = [] }
           | dictionary top_level { result = [val[0]] + val[1] }
           | group top_level { result = [val[0]] + val[1] }
           | row top_level { result = [val[0]] + val[1] }
           | table top_level { result = [val[0]] + val[1] }

  dictionary: dictionary_in dictionary_contents dictionary_out { result = Mork::Raw::Dictionary.new(values: val[1].flatten.compact) }
  dictionary_contents: { result = [] }
                     | meta dictionary_contents { result = [val[0]] + val[1] }
                     # Drop comments
                     | comments dictionary_contents { result = val[1] }
                     | aliases dictionary_contents { result = [val[0]] + val[1] }
  meta: meta_in meta_alias_in meta_alias meta_alias_out meta_out { result = Mork::Raw::MetaAlias.new(raw: val[2]) }

  group: group_in group_content group_out { result = Mork::Raw::Group.new(values: val[1]) }
  group_content: { result = [] }
               | dictionary group_content { result = [val[0]] + val[1] }
               | row group_content { result = [val[0]] + val[1] }
               | table group_content { result = [val[0]] + val[1] }

  row: row_in row_mid cells row_out { result = Mork::Raw::Row.new(raw_id: val[1], cells: val[2]) }
  cells:
       | cell cells { result = val.flatten.compact }
  cell: cell_in cell_value cell_out { result = Mork::Raw::Cell.new(raw: val[1]) }

  table: table_in table_content table_out { result = Mork::Raw::Table.new(raw_id: val[0], values: val[1]) }
  table_content: { result = [] }
               | meta_table table_content { result = [val[0]] + val[1] }
               | row table_content { result = [val[0]] + val[1] }
               | table_row_ref table_content { result = [val[0]] + val[1] }
  meta_table: meta_table_in meta_table_content meta_table_out { result = Mork::Raw::MetaTable.new(raw: val[1]) }
  meta_table_content: 
                    | meta_table_cell meta_table_content
                    | meta_table_row_ref meta_table_content

  aliases:
         | alias aliases { result = val.flatten.compact }
  alias: alias_in alias_key alias_value alias_out { result = Mork::Raw::Alias.new(key: val[1], value: val[2]) }

  comments:
          | comment comments
  comment: comment_in comment_text comment_out
end

---- header


---- inner

require "mork/lexer"
require "mork/raw"
require "mork/raw/alias"
require "mork/raw/cell"
require "mork/raw/dictionary"
require "mork/raw/group"
require "mork/raw/meta_alias"
require "mork/raw/meta_table"
require "mork/raw/row"
require "mork/raw/table"

attr_reader :lexer

def parse(str)
  @lexer = Mork::Lexer.new
  lexer.scan_setup(str)
  do_parse
end

def next_token
  lexer.next_token
end

---- footer

#
