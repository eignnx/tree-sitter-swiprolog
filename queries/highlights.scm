; Define how comments are added:
((source_file) @_source_file (#set! @_source_file bo.commentstring "\% %s"))

(compound_term
  functor: ((_) @constructor.compound
                (#set! priority 101)))

(integer) @number.integer
(rational) @number.rational
(float) @number.float

(variable) @variable

(operator) @operator

(unquoted_atom) @constant.atom.unquoted
(graphic_char_atom) @constant.atom.graphic
(quoted_atom) @string.atom
(double_quoted_string) @string.double_quote
(backtick_string) @string.backtick
(character_literal) @character

([(single_quoted_character_escape)
  (double_quoted_character_escape)
  (backticked_character_escape)
  ] @string.escape (#set! priority 150))

((format_string_placeholder) @punctuation.special (#set! priority 150))


; my_pred :- .. .
(read_term
  (binop_term
    left: [
            (compound_term functor: ((_) @keyword.function (#set! priority 130)))
            ((atom) @keyword.function (#set! priority 130))
        ]
    operator: ((operator) @_op
               (#any-of? @_op ":-" "-->" "=>" "==>" "<=>"))))


; my_pred.
; my_pred(..).
(read_term
    [ (((atom) @keyword.function) (#set! priority 130))
      (compound_term functor: ((_) @keyword.function) (#set! priority 130))
    ])

; my_mod:my_pred :- .. .
; my_mod:my_pred(..) :- .. .
(read_term
  (binop_term
    left: ((atom) @module)
    operator: ((_) @_colon (#eq? @_colon ":"))
    right: (binop_term
            left: [ (compound_term functor: (((_) @keyword.function) (#set! priority 130)))
                     (((atom) @keyword.function) (#set! priority 130))
                   ]
            operator: ((_) @_neck (#any-of? @_neck ":-" "-->" "=>" "==>" "<=>"))
            )
    ))

; my_mod:my_pred.
; my_mod:my_pred(..).
(read_term
    (binop_term
         left: [(atom) @module]
         operator: ((_) @_op (#eq? @_op ":"))
         right: [ (compound_term functor: ((_) @keyword.function) (#set! priority 130))
                  (((atom) @keyword.function) (#set! priority 130))
                ]
         ))

(read_term
  (prefix_operator_term
    operator: ((non_comma_operator) @_x
               (#eq? @_x ":-"))
    operand: (compound_term
               functor: ((_) @function.macro
                             (#set! priority 150)
                             (#any-of? @function.macro
                              "det" "op" "table" "mode"
                              "compile_predicates" "dynamic" "multifile"
                              "discontiguous" "public" "mode"
                              "non_terminal")))))
(read_term
  (prefix_operator_term
    operator: ((non_comma_operator) @_x
               (#eq? @_x ":-"))
    operand: (compound_term
               functor: ((_) @function.macro
                             (#set! priority 150)
                             (#not-any-of? @function.macro
                              "module" "use_module" "det" "op" "table" "mode"
                              "compile_predicates" "dynamic" "multifile"
                              "discontiguous" "public" "mode"
                              "non_terminal")))))

(read_term
  (prefix_operator_term
    operator: ((non_comma_operator) @_x
               (#eq? @_x ":-"))
    operand: (prefix_operator_term
               operator: ((_) @keyword.directive
                             (#set! priority 150)
                             (#any-of? @keyword.directive
                              "dynamic" "multifile" "discontiguous" "public" "mode" "non_terminal")))))

(read_term
  (prefix_operator_term
    operator: ((non_comma_operator) @_x (#eq? @_x ":-"))
    operand: (compound_term
               functor: ((_) @_y (#eq? @_y "module"))
               . ((atom) @keyword.directive
                         (#set! priority 150)))))

(read_term
  (prefix_operator_term
    operator: ((non_comma_operator) @_x (#eq? @_x ":-"))
    operand: (compound_term
               functor: ((_) @keyword.import (#eq? @keyword.import "use_module"))
               . [
                  ((atom) @module)
                  (compound_term
                   functor: ((atom) @_z
                                    (#eq? @_z "library"))
                   . [
                      ((atom) @module)
                      ((atom) @module.builtin
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
"terms" "thread" "thread_pool" "ugraphs" "url" "varnumbers" "yall"))
                      ])
                  ] . (list_literal
                        [","
                         (binop_term
                          left: ((_) @constructor)
                          operator: ((_) @_slash (#eq? @_slash "/"))
                          )
                         ]*)?
                  )))

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

(prefix_operator_term
  operator: ((non_comma_operator) @operator
               (#set! priority 105)))


(read_term_end_token) @punctuation.end_dot

(binop_term operator: ((operator) @punctuation.neck
                            (#set! priority 110)
                            (#any-of? @punctuation.neck
                                ":-" "-->" "=>" "==>" "<=>")))

((atom) @keyword.exception.nonlogical
                     (#set! priority 110)
                     (#any-of? @keyword.exception.nonlogical
                      "throw" "catch" ))
((atom) @keyword.exception.nonmonotonic
                     (#set! priority 110)
                     (#any-of? @keyword.exception.nonmonotonic
                      "!"))

((operator) @keyword.exception.nonlogical
            (#set! priority 110)
            (#any-of? @keyword.exception.nonlogical
             "=.."))
((operator) @keyword.exception.nonmonotonic
            (#set! priority 110)
            (#any-of? @keyword.exception.nonmonotonic
             "->"))

(prefix_operator_term
  operator: (non_comma_operator) @keyword.exception.nonmonotonic
    (#set! priority 110)
    (#any-of? @keyword.exception.nonmonotonic "\\+"))

(compound_term
  functor: (atom ((unquoted_atom) @keyword.exception.nonlogical
                            (#set! priority 110)
                            (#any-of? @keyword.exception.nonlogical
                             "var" "ground" "nonvar" "asserta" "assertz"
                             "retract" "retractall" "abolish" "read" "catch"
                             "setup_call_cleanup" "throw"
                             "term_variables" "read_term_from_atom" "random"
                             "date" "shell"))))
(compound_term
  functor: (atom ((unquoted_atom) @keyword.exception.nonmonotonic
                            (#set! priority 110)
                            (#any-of? @keyword.exception.nonmonotonic
                             "not" "is" "once" "memberchk"))))


((operator) @punctuation.delimiter
            (#set! priority 110)
            (#any-of? @punctuation.delimiter
             "," ";" "|"))

(binop_term
  left: ((atom) @module (#set! priority 120))
  operator: (operator ((non_comma_operator)
                            @punctuation.delimiter.module_sep
                            (#set! priority 120)
                            (#eq? @punctuation.delimiter.module_sep ":"))))

[ "[" "]" "{" "}" "(" ")" ] @punctuation.bracket

(list_literal
  "," @punctuation.delimiter.list_comma
  "|" @punctuation.delimiter.list_bar)

(dict_literal
  tag: ((_) @constructor.dict (#set! priority 111))
  "," @punctuation.delimiter.dict_comma)

(dict_key_value_pair
  dict_key: ((_) @property.dict (#set! priority 111))
  ":" @punctuation.delimiter.dict_colon)

(binop_term
  operator: ((_)
               @punctuation.delimiter.dict_dot
               (#eq? @punctuation.delimiter.dict_dot "."))
  right: ((atom) @property
                 (#set! priority 111)))

(prefix_operator_term
  operator: (_) @operator)

[
 (eol_comment)
 (multiline_comment)
] @comment

(quasi_quotation ["{|" "||" "|}"] @punctuation.delimiter.quasiquote)

