(quasi_quotation
  syntax: [
           (compound_term functor: ((atom) @injection.language))
           ((atom) @injection.language)
          ]
  quotation: ((quasi_quotation_body) @injection.content
                                     (#set! priority 200)))
