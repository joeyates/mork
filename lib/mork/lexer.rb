#--
# DO NOT MODIFY!!!!
# This file is automatically generated by rex 1.0.7
# from lexical definition file "parser/mork.rex".
#++

require 'racc/parser'
# mork
# lexical definition for Mork files
#
# usage
# $ rex parser/mork.rex --output-file lib/mork/lexer.rb

class Mork::Lexer < Racc::Parser
      require 'strscan'

      class ScanError < StandardError ; end

      attr_reader   :lineno
      attr_reader   :filename
      attr_accessor :state

      def scan_setup(str)
        @ss = StringScanner.new(str)
        @lineno =  1
        @state  = nil
      end

      def action
        yield
      end

      def scan_str(str)
        scan_setup(str)
        do_parse
      end
      alias :scan :scan_str

      def load_file( filename )
        @filename = filename
        File.open(filename, "r") do |f|
          scan_setup(f.read)
        end
      end

      def scan_file( filename )
        load_file(filename)
        do_parse
      end


        def next_token
          return if @ss.eos?

          # skips empty actions
          until token = _next_token or @ss.eos?; end
          token
        end

        def _next_token
          text = @ss.peek(1)
          @lineno  +=  1  if text == "\n"
          token = case @state
            when nil
          case
                  when (text = @ss.scan(/\/\/\s<!--\s<mdb:mork:z.*\n/))
                     action { @stack = [];            [:magic, text] }

                  when (text = @ss.scan(/\/\//))
                     action { @state = :COMMENT;      [:comment_in, text] }

                  when (text = @ss.scan(/\n/))
                     action { }

                  when (text = @ss.scan(/</))
                     action { @stack.push(@state); @state = :DICTIONARY;   [:dictionary_in, text] }

                  when (text = @ss.scan(/\[/))
                     action { @stack.push(@state); @state = :ROW; [:row_in, text] }

                  when (text = @ss.scan(/\{[\-A-Z0-9]+(:[^\s]+\s)?/))
                     action { @stack.push(@state); @state = :TABLE; [:table_in, text] }

                  when (text = @ss.scan(/@\$\${[0-9A-F]+{@/))
                     action { @state = :GROUP;       [:group_in, text] }

          
          else
            text = @ss.string[@ss.pos .. -1]
            raise  ScanError, "can not match: '" + text + "'"
          end  # if

            when :COMMENT
          case
                  when (text = @ss.scan(/\n/))
                     action { @state = @stack.pop;    [:comment_out, text] }

                  when (text = @ss.scan(/.*/))
                     action {                         [:comment_text, text] }

          
          else
            text = @ss.string[@ss.pos .. -1]
            raise  ScanError, "can not match: '" + text + "'"
          end  # if

            when :DICTIONARY
          case
                  when (text = @ss.scan(/\s+/))
                     action { }

                  when (text = @ss.scan(/>/))
                     action { @state = @stack.pop;    [:dictionary_out, text] }

                  when (text = @ss.scan(/\/\//))
                     action { @stack.push(@state); @state = :COMMENT;      [:comment_in, text] }

                  when (text = @ss.scan(/</))
                     action { @state = :META;         [:meta_in, text] }

                  when (text = @ss.scan(/\(/))
                     action { @state = :ALIAS;        [:alias_in, text] }

          
          else
            text = @ss.string[@ss.pos .. -1]
            raise  ScanError, "can not match: '" + text + "'"
          end  # if

            when :ALIAS
          case
                  when (text = @ss.scan(/\)/))
                     action { @state = :DICTIONARY;   [:alias_out, text] }

                  when (text = @ss.scan(/[0-9A-F]+(?==|$)/))
                     action { @state = :ALIAS_VALUE;  [:alias_key, text] }

          
          else
            text = @ss.string[@ss.pos .. -1]
            raise  ScanError, "can not match: '" + text + "'"
          end  # if

            when :ALIAS_VALUE
          case
                  when (text = @ss.scan(/\n/))
                     action { }

                  when (text = @ss.scan(/\s+/))
                     action { }

                  when (text = @ss.scan(/=(?=\))/))
                     action { @state = :ALIAS;        [:alias_value, nil] }

                  when (text = @ss.scan(/=(\\\)|[^\)])+/))
                     action { @state = :ALIAS; value = text[1..]; [:alias_value, value] }

          
          else
            text = @ss.string[@ss.pos .. -1]
            raise  ScanError, "can not match: '" + text + "'"
          end  # if

            when :META
          case
                  when (text = @ss.scan(/\s+/))
                     action { }

                  when (text = @ss.scan(/>/))
                     action { @state = :DICTIONARY;   [:meta_out, text] }

                  when (text = @ss.scan(/\(/))
                     action { @state = :META_ALIAS;   [:meta_alias_in, text] }

          
          else
            text = @ss.string[@ss.pos .. -1]
            raise  ScanError, "can not match: '" + text + "'"
          end  # if

            when :META_ALIAS
          case
                  when (text = @ss.scan(/\)/))
                     action { @state = :META;         [:meta_alias_out, text] }

                  when (text = @ss.scan(/[^=]+=[^\)]+/))
                     action {                         [:meta_alias, text] }

          
          else
            text = @ss.string[@ss.pos .. -1]
            raise  ScanError, "can not match: '" + text + "'"
          end  # if

            when :ROW
          case
                  when (text = @ss.scan(/[\-A-Z0-9]+(:[^\(]+)?/))
                     action { @state = :CELLS;  [:row_mid, text] }

          
          else
            text = @ss.string[@ss.pos .. -1]
            raise  ScanError, "can not match: '" + text + "'"
          end  # if

            when :CELLS
          case
                  when (text = @ss.scan(/\s+/))
                     action { }

                  when (text = @ss.scan(/\n/))
                     action { }

                  when (text = @ss.scan(/\]/))
                     action { @state = @stack.pop;    [:row_out, text] }

                  when (text = @ss.scan(/\(/))
                     action { @state = :CELL;         [:cell_in, text] }

          
          else
            text = @ss.string[@ss.pos .. -1]
            raise  ScanError, "can not match: '" + text + "'"
          end  # if

            when :CELL
          case
                  when (text = @ss.scan(/\)/))
                     action { @state = :CELLS;        [:cell_out, text] }

                  when (text = @ss.scan(/\^[0-9A-F]+=[^\)]*/))
                     action {                   [:cell_value, text] }

                  when (text = @ss.scan(/\^[0-9A-F]+\^[0-9A-F]+/))
                     action {               [:cell_value, text] }

          
          else
            text = @ss.string[@ss.pos .. -1]
            raise  ScanError, "can not match: '" + text + "'"
          end  # if

            when :TABLE
          case
                  when (text = @ss.scan(/\s+/))
                     action { }

                  when (text = @ss.scan(/\}/))
                     action { @state = @stack.pop;    [:table_out, text] }

                  when (text = @ss.scan(/\{/))
                     action { @state = :META_TABLE;   [:meta_table_in, text] }

                  when (text = @ss.scan(/\[/))
                     action { @stack.push(@state); @state = :ROW; [:row_in, text] }

                  when (text = @ss.scan(/[A-Z0-9]+(:[^\s]+\s)?/))
                     action {                  [:table_row_ref, text] }

          
          else
            text = @ss.string[@ss.pos .. -1]
            raise  ScanError, "can not match: '" + text + "'"
          end  # if

            when :META_TABLE
          case
                  when (text = @ss.scan(/\}/))
                     action { @state = :TABLE;         [:meta_table_out, text] }

                  when (text = @ss.scan(/\([^\)]+\)/))
                     action {                          [:meta_table_cell, text] }

                  when (text = @ss.scan(/[A-Z0-9]+(:[^\s]+\s)?/))
                     action {                  [:meta_table_row_ref, text] }

          
          else
            text = @ss.string[@ss.pos .. -1]
            raise  ScanError, "can not match: '" + text + "'"
          end  # if

            when :GROUP
          case
                  when (text = @ss.scan(/\n/))
                     action { }

                  when (text = @ss.scan(/@\$\$}[0-9A-F]+}@/))
                     action { @state = nil;          [:group_out, text] }

                  when (text = @ss.scan(/</))
                     action { @stack.push(@state); @state = :DICTIONARY;   [:dictionary_in, text] }

                  when (text = @ss.scan(/\[/))
                     action { @stack.push(@state); @state = :ROW; [:row_in, text] }

                  when (text = @ss.scan(/\{[\-A-Z0-9]+(:[^\s]+\s)?/))
                     action { @stack.push(@state); @state = :TABLE; [:table_in, text] }

          
          else
            text = @ss.string[@ss.pos .. -1]
            raise  ScanError, "can not match: '" + text + "'"
          end  # if

        else
          raise  ScanError, "undefined state: '" + state.to_s + "'"
        end  # case state
          token
        end  # def _next_token

end # class
