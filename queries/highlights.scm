(compound_term
  functor: (_) @constant)

(number) @number
(variable) @variable

(operator) @operator

(unquoted_atom) @constant
(quoted_atom) @string
(double_quoted_string) @string
(backtick_string) @string

(single_quoted_character_escape) @punctuation.special
(double_quoted_character_escape) @punctuation.special
(backticked_character_escape) @punctuation.special

(format_string_placeholder) @punctuation.special

(clause
  (operator_term
    left: [
        (compound_term functor: ((_) @function) (#set! priority 110))
        (((atom) @function) (#set! priority 110))
    ]
    operator: (
               (operator) @_op
               (#any-of? @_op ":-" "-->" "==>" "<=>")
               )
    ))

(clause
    [
        (((atom) @function) (#set! priority 110))
        (compound_term functor: ((_) @function) (#set! priority 110))
     ]
)

(operator_term operator: ((operator) @keyword.function
                            (#set! priority 110)
                            (#any-of? @keyword.function
                                ":-" "-->" "==>" "<=>")))
