; EXPERIMENTAL - I'm not sure if this is helfup at all.

(read_term) @local.scope

(read_term
  (binop_term
    left: (compound_term
            functor: (_)
            (variable) @local.definition)
    operator: ((operator) @_op
               (#any-of? @_op ":-" "-->" "==>" "<=>"))))

(variable) @local.reference
