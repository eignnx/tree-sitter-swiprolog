(compound_term
  functor: ((_) @constant
                (#set! priority 101)))

(integer) @number
(rational) @number
(float) @number.float

(variable) @variable

(operator) @operator

(unquoted_atom) @constant
(graphic_char_atom) @constant
(quoted_atom) @string
(double_quoted_string) @string
(backtick_string) @string
(character_literal) @character

(single_quoted_character_escape) @string.escape
(double_quoted_character_escape) @string.escape
(backticked_character_escape) @string.escape

(format_string_placeholder) @string.special


(read_term
  (binop_term
    left: [ (compound_term functor: ((_) @function) (#set! priority 110))
            (((atom) @function) (#set! priority 130))]
    operator: ((operator) @_op
               (#any-of? @_op ":-" "-->" "==>" "<=>"))))

(read_term
    [ (((atom) @function) (#set! priority 130))
      (compound_term functor: ((_) @function) (#set! priority 110))])

(read_term
  (prefix_operator_term
    operator: ((non_comma_operator) @keyword.function
               (#set! priority 110)
               (#eq? @keyword.function ":-"))))

(read_term
  (prefix_operator_term
    operator: ((non_comma_operator) @_x
               (#eq? @_x ":-"))
    operand: (compound_term
               functor: ((_) @function.macro
                             (#set! priority 150)
                             (#any-of? @function.macro
                              "module" "use_module" "det" "op" "table" "mode" "compile_predicates"
                              "dynamic" "multifile" "discontiguous" "public" "mode" "non_terminal")))))
(read_term
  (prefix_operator_term
    operator: ((non_comma_operator) @_x
               (#eq? @_x ":-"))
    operand: (compound_term
               functor: ((_) @function.macro
                             (#set! priority 150)
                             (#not-any-of? @function.macro
                              "module" "use_module" "det" "op" "table" "mode" "compile_predicates"
                              "dynamic" "multifile" "discontiguous" "public" "mode" "non_terminal")))))

(read_term
  (prefix_operator_term
    operator: ((non_comma_operator) @_x
               (#eq? @_x ":-"))
    operand: (prefix_operator_term
               operator: ((_) @function.macro
                             (#set! priority 150)
                             (#any-of? @function.macro
                              "dynamic" "multifile" "discontiguous" "public" "mode" "non_terminal")))))
(read_term
  (prefix_operator_term
    operator: ((non_comma_operator) @_x (#eq? @_x ":-"))
    operand: (compound_term
               functor: ((_) @_y (#eq? @_y "module"))
               . ((atom) @module
                         (#set! priority 150)))))
(read_term
  (prefix_operator_term
    operator: ((non_comma_operator) @_x (#eq? @_x ":-"))
    operand: (compound_term
               functor: ((_) @_y (#eq? @_y "use_module"))
               . ((atom) @module
                         (#set! priority 150)))))

(read_term
  (prefix_operator_term
    operator: ((non_comma_operator) @_x (#eq? @_x ":-"))
    operand: (compound_term
               functor: ((_) @_y (#eq? @_y "use_module"))
               . (compound_term
                   functor: ((atom) @keyword.import
                                    (#set! priority 110)
                                    (#eq? @keyword.import "library"))))))

(read_term
  (prefix_operator_term
    operator: ((non_comma_operator) @_x (#eq? @_x ":-"))
    operand: (compound_term
               functor: ((_) @_y (#eq? @_y "use_module"))
               . (compound_term
                   functor: ((atom) @_z
                                    (#eq? @_z "library"))
                   . ((atom) @module.builtin
                             (#set! priority 110)
                             (#any-of? @module.builtin
"aggregate" "ansi_term" "apply" "assoc" "broadcast" "charsio" "check" "clpb"
"clpfd" "clpqr" "csv" "debug" "dicts" "error" "exceptions" "fastrw" "gensym"
"heaps" "increval" "intercept" "iostream" "listing" "lists" "macros" "main"
"nb_set" "www_browser" "occurs" "option" "optparse" "ordsets" "pairs"
"persistency" "pio" "portray_text" "predicate_options" "prolog_coverage"
"prolog_debug" "prolog_jiti" "prolog_trace" "prolog_versions" "prolog_xref"
"quasi_quotations" "random" "rbtrees" "readutil" "record" "registry" "rwlocks"
"settings" "statistics" "strings" "simplex" "solution_sequences" "tables"
"terms" "thread" "thread_pool" "ugraphs" "url" "varnumbers" "yall"))))))

(read_term
  (prefix_operator_term
    operator: ((non_comma_operator) @_x (#eq? @_x ":-"))
    operand: (compound_term
               functor: ((_) @_y (#eq? @_y "use_module"))
               . [ (atom) @module

                   (binop_term
                     operator: (operator) @_op (#eq? @_op "/")) @module

                   (compound_term
                     functor: (_) @module
                     (_) @module)
                 ]  (#set! priority 105))))

;TODO: "dcg/basics" "dcg/high_order"







(read_term_end_token) @punctuation.delimiter

(binop_term operator: ((operator) @keyword.function
                            (#set! priority 110)
                            (#any-of? @keyword.function
                                ":-" "-->" "==>" "<=>")))

((atom) @keyword.exception
                     (#set! priority 110)
                     (#any-of? @keyword.exception
                      "!" "throw" "catch" ))

((operator) @keyword.exception
            (#set! priority 110)
            (#any-of? @keyword.exception
             "->" "=.."))
(prefix_operator_term
  operator: (non_comma_operator) @keyword.exception
    (#set! priority 110)
    (#any-of? @keyword.exception "\\+"))



((operator) @punctuation.delimiter
            (#set! priority 110)
            (#any-of? @punctuation.delimiter
             "," ";" "|"))

(compound_term
  functor: (atom ((unquoted_atom) @keyword.exception
                            (#set! priority 110)
                            (#any-of? @keyword.exception
                             "var" "ground" "nonvar" "not" "is" "asserta"
                             "assertz" "retract" "retractall" "abolish" "read"
                             "once" "memberchk" "term_variables"
                             "read_term_from_aotm" "random" "date" "shell"))))

(binop_term
  left: ((atom) @module (#set! priority 120))
  operator: (operator ((non_comma_operator) @punctuation.delimiter
                                            (#set! priority 120)
                                            (#eq? @punctuation.delimiter ":"))))

[ "[" "]" "{" "}" "(" ")" ] @punctuation.bracket

(list_literal
  "," @punctuation.delimiter
  "|" @punctuation.delimiter)

(dict_literal
  tag: ((_) @constructor (#set! priority 111))
  "," @punctuation.delimiter)

(dict_key_value_pair
  dict_key: ((_) @property (#set! priority 111))
  ":" @punctuation.delimiter)

(binop_term
  operator: ((operator) @_op
                        (#eq? @_op "."))
  right: ((atom) @property
                 (#set! priority 111)))

(prefix_operator_term
  operator: (non_comma_operator) @operator)

[
 (eol_comment)
 (multiline_comment)
] @comment

(quasi_quotation
  "{|" @punctuation.delimiter
  "||" @punctuation.delimiter
  "|}" @punctuation.delimiter)

