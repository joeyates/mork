# mork
# lexical definition for Mork files
#
# Generate Ruby lexer:
# $ rex parser/mork.rex --output-file lib/mork/lexer.rb

class Mork::Lexer
macro
  MAGIC             \/\/\s<!--\s<mdb:mork:z.*\n
  COMMENT           \/\/
  ALIAS             \(
  DICTIONARY        <
  ROW               \[
  TABLE             \{

rule
  # As a hack, we assume Mork files always start with the magic string
  # In the first rule, we initialize a stack that allows rules to be nested:
  # On entering a nested rule, the current state is pushed onto the stack,
  # and it is popped off again when the subrule completes.
                 {MAGIC}       { @stack = [];            [:magic, text] }

                 {COMMENT}     { @state = :COMMENT;      [:comment_in, text] }
                 \n            { }
  :COMMENT       \n            { @state = @stack.pop;    [:comment_out, text] }
  :COMMENT       .*            {                         [:comment_text, text] }

                 {DICTIONARY}  { @stack.push(@state); @state = :DICTIONARY;   [:dictionary_in, text] }
  :DICTIONARY    \s+           { }
  :DICTIONARY    >             { @state = @stack.pop;    [:dictionary_out, text] }
  :DICTIONARY    {COMMENT}     { @stack.push(@state); @state = :COMMENT;      [:comment_in, text] }
  :DICTIONARY    {DICTIONARY}  { @state = :META;         [:meta_in, text] }
  :DICTIONARY    {ALIAS}       { @state = :ALIAS;        [:alias_in, text] }

  :ALIAS         \)            { @state = :DICTIONARY;   [:alias_out, text] }
  :ALIAS         [0-9A-F]+(?==|$) { @state = :ALIAS_VALUE;  [:alias_key, text] }
  :ALIAS_VALUE   \n            { }
  :ALIAS_VALUE   \s+           { }
  :ALIAS_VALUE   =(?=\))        { @state = :ALIAS;        [:alias_value, nil] }
  # Handle `\)` as an escaped `)`
  :ALIAS_VALUE   =(\\\)|[^\)])+ { @state = :ALIAS; value = text[1..]; [:alias_value, value] }

  :META          \s+           { }
  :META          >             { @state = :DICTIONARY;   [:meta_out, text] }
  :META          {ALIAS}       { @state = :META_ALIAS;   [:meta_alias_in, text] }

  :META_ALIAS    \)            { @state = :META;         [:meta_alias_out, text] }
  :META_ALIAS    [^=]+=[^\)]+  {                         [:meta_alias, text] }

                 {ROW}         { @stack.push(@state); @state = :ROW; [:row_in, text] }
  :ROW           [\-A-Z0-9]+(:[^\(]+)? { @state = :CELLS;  [:row_mid, text] }

  :CELLS         \s+           { }
  :CELLS         \n            { }
  :CELLS         \]            { @state = @stack.pop;    [:row_out, text] }
  :CELLS         \(            { @state = :CELL;         [:cell_in, text] }

  :CELL          \)            { @state = :CELLS;        [:cell_out, text] }
  :CELL          \^[0-9A-F]+=[^\)]*  {                   [:cell_value, text] }
  :CELL          \^[0-9A-F]+\^[0-9A-F]+  {               [:cell_value, text] }

                 {TABLE}[\-A-Z0-9]+(:[^\s]+\s)? { @stack.push(@state); @state = :TABLE; [:table_in, text] }
  :TABLE         \s+           { }
  :TABLE         \}            { @state = @stack.pop;    [:table_out, text] }
  :TABLE         {TABLE}       { @state = :META_TABLE;   [:meta_table_in, text] }
  :TABLE         {ROW}         { @stack.push(@state); @state = :ROW; [:row_in, text] }
  :TABLE         [A-Z0-9]+(:[^\s]+\s)? {                  [:table_row_ref, text] }

  :META_TABLE    \}            { @state = :TABLE;         [:meta_table_out, text] }
  :META_TABLE    \([^\)]+\)    {                          [:meta_table_cell, text] }
  :META_TABLE    [A-Z0-9]+(:[^\s]+\s)? {                  [:meta_table_row_ref, text] }

                 @\$\${[0-9A-F]+{@ { @state = :GROUP;       [:group_in, text] }
  :GROUP         \n            { }
  :GROUP         @\$\$}[0-9A-F]+}@ { @state = nil;          [:group_out, text] }
  :GROUP         {DICTIONARY}  { @stack.push(@state); @state = :DICTIONARY;   [:dictionary_in, text] }
  :GROUP         {ROW}         { @stack.push(@state); @state = :ROW; [:row_in, text] }
  :GROUP         {TABLE}[\-A-Z0-9]+(:[^\s]+\s)? { @stack.push(@state); @state = :TABLE; [:table_in, text] }
end
