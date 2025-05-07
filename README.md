# tree-sitter-swiprolog

## Features
-[X] format string placeholders
    -[X] in double quoted strings (`format("xxx~pxxx", [123])`)
    -[X] in backtick quoted strings (``format(`xxx~pxxx`, [123])``)
    -[X] in single quoted atoms (`format('xxx~pxxx', [123])`)
-[X] dictionary literals
    -[X] atom tags (`tag{key1: value1, key2: value2}`)
    -[X] variable tags (`Tag{key1: value1, key2: value2}`)
    -[X] property access (`MyDict.my_property`)
    -[ ] member function access (`MyDict.my_func()`)
-[X] specially highlighted non-monotonic/non-logical predicates (`!`, `->`, 
     `\+`, `var`, `=..`, `assertz`, etc.)
-[X] text literals
    -[X] double quoted strings (`"asdf"`)
    -[X] backtick quoted strings (``asdf``)
    -[X] single quoted atoms (`'asdf'`)
-[X] character escapes in
    -[X] double quoted strings (`"asdf\nasdf"`)
    -[X] backtick quoted strings (`` `asdf\nasdf` ``)
    -[X] single quoted atoms (`'asdf\nasdf'`)
-[-] operators
    -[X] prefix operators
    -[X] infix operators
    -[ ] postfix operators
-[ ] quasi-quotation syntax (`{|html(Name, Address)||<tr><td>Name</td>Address</tr>|}`)

