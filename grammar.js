/**
 * @file Prolog syntax aimed at SWI Prolog
 * @author eignnx <eignnx@gmail.com>
 * @license MIT
 */

/// <reference types="tree-sitter-cli/dsl" />
// @ts-check

module.exports = grammar({
  name: "swiprolog",

  extras: $ => [
    /\s+/,
    $.eol_comment,
  ],

  conflicts: $ => [
    [$.non_comma_operator, $.graphic_char_atom]
  ],

  externals: $ => [
    $.read_term_end_token,
  ],

  rules: {
    source_file: $ => repeat($.read_term),

    read_term: $ => seq(
      $._term,
      $.read_term_end_token,
    ),

    _term: $ => choice(
      $._restricted_operators_term,
    ),

    _restricted_operators_term: $ => choice(
      $.compound_term,
      $.string,
      $.variable,
      $.list_literal,
      $.prefix_operator_term,
      prec(1, $.atom),
      $.number,
      prec(10, $.binop_term),
      $.parenthesized_term,
      $.curly_braced_term,
      $.dict_literal,
    ),

    compound_term: $ => prec(100, seq(
      field("functor", $.atom),
        "(",
        prec(5, $._restricted_operators_term),
        repeat(seq(
          ",",
          prec(5, $._restricted_operators_term),
        )),
        ")",
    )),

    atom: $ => choice(
      $.unquoted_atom,
      $.quoted_atom,
      choice(
        $.graphic_char_atom,
        "!",
      ),
    ),

    graphic_char_atom: $ => /[-+*/\\^<>=~:.?@#$&]+/,

    unquoted_atom: $ => /[a-z][a-zA-Z_]*/,

    quoted_atom: $ => seq(
      /'/,
      repeat($._single_quoted_inner),
      /'/,
    ),

    _single_quoted_inner: $ => choice(
      $.single_quoted_character_escape,
      $.format_string_placeholder,
      $.single_quoted_content,
    ),

    format_string_placeholder: $ => token.immediate(seq(
      "~",
      choice(
        /(`.)?t/,
        seq(
          optional(/\d+|\*/),
          optional(":"),
          /[acd~DeEgfGiknNpqrR@s\|\+wW]/
        ),
      )
    )),

    single_quoted_character_escape: $ => /\\[nrtv\\']/,
    single_quoted_content: $ => /[^\\~']+/,

    string: $ => choice(
      $.double_quoted_string,
      $.backtick_string,
    ),

    double_quoted_string: $ => seq(
      /"/,
      repeat($._double_quoted_string_inner),
      /"/,
    ),
    _double_quoted_string_inner: $ => choice(
      $.format_string_placeholder,
      $.double_quoted_character_escape,
      $.double_quoted_content,
    ),
    double_quoted_character_escape: $ => /\\[nrtv\\"]/,
    double_quoted_content: $ => /[^\\~"]+/,

    backtick_string: $ => seq(
      /`/,
      repeat($._backtick_string_inner),
      /`/,
    ),
    _backtick_string_inner: $ => choice(
      $.format_string_placeholder,
      $.backticked_character_escape,
      $.backticked_content,
    ),
    backticked_character_escape: $ => /\\[nrtv\\`]/,
    backticked_content: $ => /[^\\~`]+/,

    variable: $ => /[_A-Z][a-zA-Z0-9_]*/,

    list_literal: $ => prec(100, choice(
      seq("[", "]"),
      seq(
        "[",
        prec(15, $._restricted_operators_term),
        prec.left(50, repeat(seq(",", prec(15, $._restricted_operators_term)))),
        optional(seq("|", $._term)),
        "]",
      ),
    )),

    number: $ => choice(
      /0[xX][0-9a-fA-F]+/,
      /0b[01]+/,
      /0o[0-7]+/,
      /[-+]?[1-9][0-9]*/,
      /[-+]?0/,
    ),

    binop_term: $ => prec.right(seq(
      field("left", $._term),
      field("operator", $.operator),
      field("right", $._term),
    )),

    operator: $ => choice(
      $.non_comma_operator,
      ",",
      ";",
    ),
    non_comma_operator: $ => /[-+*/\\^<>=~:.?@#$&]+/,

    prefix_operator_term: $ => prec(100, seq(
      field("operator", $.non_comma_operator),
      field("operand", $._term),
    )),

    parenthesized_term: $ => seq("(", $._term, ")"),
    curly_braced_term: $ => seq("{", $._term, "}"),

    dict_literal: $ => seq(
      field("tag", $.atom),
      field("keys_values", delimited_comma_sep("{", $.dict_key_value_pair, "}")),
    ),

    dict_key_value_pair: $ => prec.left(20, seq(
      field("dict_key", $._non_graphic_char_atom),
      ":",
      field("dict_value", $._restricted_operators_term),
    )),

    _non_graphic_char_atom: $ => choice(
      $.unquoted_atom,
      $.quoted_atom,
    ),

    eol_comment: $ => /%.*/,
  },
});

function delimited_comma_sep(open, item, close) {
  return seq(
    open,
    optional(seq(item, repeat(seq(",", item)))),
    close,
  )
}
