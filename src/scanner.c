// CHATGPT GENERATED:

// scanner.c: Tree‑sitter external scanner for Prolog term terminator
// This scanner recognizes a dot '.' only if followed by a layout character
// (space, tab, newline, carriage return), a '%' (comment), or EOF. It emits
// READ_TERM_END_TOKEN in those cases.

#include <tree_sitter/parser.h>
#include "tree_sitter/alloc.h"

enum TokenType {
  READ_TERM_END_TOKEN, // The `.` at the end of a read term.
  QUASI_QUOTATION_BODY,
};

typedef struct {
    char c_requires_non_empty_struct_so_here_we_are;
} Scanner;

Scanner *tree_sitter_swiprolog_external_scanner_create() {
    Scanner *scanner = (Scanner *) ts_malloc(sizeof(Scanner));
    return scanner;
}

bool tree_sitter_swiprolog_external_scanner_scan(
  Scanner *scanner,
  TSLexer *lexer,
  const bool *valid_symbols
) {
    if (valid_symbols[READ_TERM_END_TOKEN] && lexer->lookahead == '.') {
        // Consume '.'
        lexer->advance(lexer, false);

        switch (lexer->lookahead) {
        case ' ':
        case '\t':
        case '\n':
        case '\r':
        case '%':
            // NOTE:
            // ?- true.%valid
            // ?- true. %valid
            // ?- true./*invalid*/
            // ?- true. /*valid*/
            lexer->result_symbol = READ_TERM_END_TOKEN;
            return true;
        default:
            if (lexer->eof(lexer)) {
                lexer->result_symbol = READ_TERM_END_TOKEN;
                return true;
            }
        }

    } else if (valid_symbols[QUASI_QUOTATION_BODY]) {
        // printf("Possible quasi-quotation body:\n");
        while (!lexer->eof(lexer)) {
            while (lexer->lookahead != '|' && !lexer->eof(lexer)) {
                // printf("%c", lexer->lookahead);
                lexer->advance(lexer, false);
                lexer->mark_end(lexer);
            }
            // Consume '|'
            lexer->advance(lexer, false);
            if (lexer->lookahead == '}') {
                lexer->advance(lexer, false); // Consume `}`
                lexer->result_symbol = QUASI_QUOTATION_BODY;
                // printf("\nFOUND CLOSING `|}`\n");
                return true;
            }
            // Must have been a single embedded `|`, but not the start of `|}`.
            // Try again.
            // printf("\nTrying again after encountering `|`...\n");
        }
    }

  // No match, rollback.
  return false;
}

unsigned tree_sitter_swiprolog_external_scanner_serialize(
    Scanner *scanner,
    char *buffer
) {
    return sizeof(Scanner);
}

void tree_sitter_swiprolog_external_scanner_deserialize(
  Scanner *scanner,
  const char *buffer,
  unsigned length
) { }

void tree_sitter_swiprolog_external_scanner_destroy(Scanner *scanner) {
    ts_free((void*) scanner);
}

