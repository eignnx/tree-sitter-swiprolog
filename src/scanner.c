// CHATGPT GENERATED:

// scanner.c: Tree‑sitter external scanner for Prolog term terminator
// This scanner recognizes a dot '.' only if followed by a layout character
// (space, tab, newline, carriage return), a '%' (comment), or EOF. It emits
// READ_TERM_END_TOKEN in those cases.

#include <tree_sitter/parser.h>

enum TokenType {
  READ_TERM_END_TOKEN, // The `.` at the end of a read term.
};

void *tree_sitter_swiprolog_external_scanner_create() { return NULL; }

bool tree_sitter_swiprolog_external_scanner_scan(
  void *payload,
  TSLexer *lexer,
  const bool *valid_symbols
) {
  // Only try when READ_TERM_END_TOKEN is expected
  if (!valid_symbols[READ_TERM_END_TOKEN]) return false;

  // Check current character
  if (lexer->lookahead != '.') return false;

  // Consume '.'
  lexer->advance(lexer, false);

  // Peek next character
  int32_t next = lexer->lookahead;
  if (next == 0 || next == ' ' || next == '\t' || next == '\n' || next == '\r' || next == '%') {
    lexer->result_symbol = READ_TERM_END_TOKEN;
    return true;
  }

  // Not a terminator, rollback
  return false;
}

unsigned tree_sitter_swiprolog_external_scanner_serialize(
  void *payload,
  char *buffer
) {
  return 0;
}

void tree_sitter_swiprolog_external_scanner_deserialize(
  void *payload,
  const char *buffer,
  unsigned length
) {}

void tree_sitter_swiprolog_external_scanner_destroy(void *payload) {}

