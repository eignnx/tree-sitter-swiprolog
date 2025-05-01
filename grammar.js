/**
 * @file Prolog syntax aimed at SWI Prolog
 * @author eignnx <eignnx@gmail.com>
 * @license MIT
 */

/// <reference types="tree-sitter-cli/dsl" />
// @ts-check

module.exports = grammar({
  name: "swiprolog",

  rules: {
    source_file: $ => repeat(choice(
      $.directive,
      $.clause,
    )),

    directive: $ => seq(
      ":-",
      $._term,
      ".",
    ),

    clause: $ => seq(
      $._term,
      optional(
        seq(
          ":-",
          $._term,
        ),
      ),
      ".",
    ),

    _term: $ => choice(
      $._restricted_operators_term,
    ),

    _restricted_operators_term: $ => choice(
      $.compound_term,
      $.atom,
      $.string,
      $.variable,
    ),

    compound_term: $ => seq(
      field("functor", $.atom),
        "(",
        $._restricted_operators_term,
        repeat(seq(
          ",",
          $._restricted_operators_term,
        )),
        ")",
    ),


    atom: $ => choice(
      $.unquoted_atom,
      $.quoted_atom,
    ),

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

    format_string_placeholder: $ => /~[~nt]/,

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
  },
});
