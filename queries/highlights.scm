(compound_term
  functor: (_) @constant)

(number) @number
(variable) @variable

(operator) @operator

(unquoted_atom) @constant
(graphic_char_atom) @constant
(quoted_atom) @string
(double_quoted_string) @string
(backtick_string) @string

(single_quoted_character_escape) @punctuation.special
(double_quoted_character_escape) @punctuation.special
(backticked_character_escape) @punctuation.special

(format_string_placeholder) @punctuation.special

(read_term
  (binop_term
    left: [
        (compound_term functor: ((_) @function) (#set! priority 110))
        (((atom) @function) (#set! priority 110))
    ]
    operator: (
               (operator) @_op
               (#any-of? @_op ":-" "-->" "==>" "<=>")
               )
    ))

(read_term
    [
        (((atom) @function) (#set! priority 110))
        (compound_term functor: ((_) @function) (#set! priority 110))
     ]
)

(read_term
  (prefix_operator_term
    operator: ((non_comma_operator) @keyword.function
               (#set! priority 110)
               (#eq? @keyword.function ":-"))))

(read_term_end_token) @punctuation.delimiter

(binop_term operator: ((operator) @keyword.function
                            (#set! priority 110)
                            (#any-of? @keyword.function
                                ":-" "-->" "==>" "<=>")))

((graphic_char_atom) @keyword.exception
                     (#set! priority 110)
                     (#any-of? @keyword.exception
                      "!" ))

((operator) @keyword.exception
            (#set! priority 110)
            (#any-of? @keyword.exception
             "->" "\\=" "=.."))
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

(dict_literal
  tag: ((_) @constructor (#set! priority 111))
  "{" @punctuation.delimiter
  "," @punctuation.delimiter
  "}" @punctuation.delimiter)

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

(eol_comment) @comment

(quasi_quotation
  "{|" @string
  "||" @string
  (quasi_quotation_body) @string)

(quasi_quotation
  (compound_term
    functor: (atom) @_head
             (#matches? @_head "html"))
  (quasi_quotation_body) @injection.content
                         (#set! injection.language "html"))

