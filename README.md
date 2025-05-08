# tree-sitter-swiprolog
An opinionated clean-slate rewrite of `tree-sitter-prolog` with the aim of supporting the language extensions provided by SWI-Prolog (dictionary literals, quasi-quotation, rational number literals) and enhancing common Prolog language features (highlighting format string placeholders, highlighting clause head predicates).

## LIMITATIONS
This is in-development, so currently it is not designed to work on `*.pl` files. Use the temporary `*.swipl` file extension to test it out.

## Feature Progress
- [X] format string placeholders
    - [X] in double quoted strings (`format("xxx~pxxx", [123])`)
    - [X] in backtick quoted strings (``format(`xxx~pxxx`, [123])``)
    - [X] in single quoted atoms (`format('xxx~pxxx', [123])`)
- [ ] dictionary literals
    - [X] atom tags (`tag{key1: value1, key2: value2}`)
    - [X] variable tags (`Tag{key1: value1, key2: value2}`)
    - [X] property access (`MyDict.my_property`)
    - [ ] member function access (`MyDict.my_func()`)
- [X] specially highlighted non-monotonic/non-logical predicates (`!`, `->`, 
     `\+`, `var`, `=..`, `assertz`, etc.)
- [X] text literals
    - [X] double quoted strings (`"asdf"`)
    - [X] backtick quoted strings (``asdf``)
    - [X] single quoted atoms (`'asdf'`)
- [X] character escapes in
    - [X] double quoted strings (`"asdf\nasdf"`)
    - [X] backtick quoted strings (`` `asdf\nasdf` ``)
    - [X] single quoted atoms (`'asdf\nasdf'`)
- [ ] operators
    - [X] prefix operators
    - [X] infix operators
    - [ ] postfix operators
- [ ] quasi-quotation syntax (`{|html(Name, Address)||<tr><td>Name</td>Address</tr>|}`)
- [ ] character literals (`0'a`)
- [ ] character literal escape sequence (`0'\x3F`)
- [X] integer literals (decimal, binary, octal, hex)
- [ ] float literals
- [ ] rational number literals (`5r3`)

## User Installation (Assumes you are an end-user and use Neovim with Packer)
Paste the following into your `init.lua` (or wherever, as long as it's run at startup):

```lua
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.swiprolog = {
  install_info = {
    url = "eignnx/tree-sitter-swiprolog", -- local path or git repo
    files = {
        "src/parser.c",
        "src/scanner.c",
    },
    branch = "main",
    generate_requires_npm = false,
  },
  filetype = "swipl",
}

vim.treesitter.language.register('swiprolog', 'swipl')
vim.filetype.add({
  extension = {
    swipl = 'swiprolog',
  }
})
```

Ensure that code is run (by restarting nvim, or `:source`ing the file.

Run `:PackerSync`.

Next you (probably) need to copy over the query file. In this repo, download `queries/highlights.scm` and copy the file into either:
- `~/.config/nvim/after/queries/swiprolog/` (Unix-like operating systems)
- `~/AppData/Local/nvim/after/queries/swiprolog/` (Windows)

## Development Environment Setup
1. Make sure you have the `tree-sitter` cli program (`cargo install tree-sitter-cli` if you have `cargo`).
1. Clone this repo somewhere (lets say you save under your home directory as `~/tree-sitter-swiprolog`)
1. Edit the following in your neovim init file (`init.lua`) (or wherever) changin `url` to the place you cloned the repo:
    ```lua
    local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
    parser_config.swiprolog = {
    install_info = {
        url = "~/tree-sitter-swiprolog", -- local path or git repo
        files = {
            "src/parser.c",
            "src/scanner.c",
        },
        -- branch = "main",
        generate_requires_npm = false,
    },
    filetype = "swipl",
    }

    vim.treesitter.language.register('swiprolog', 'swipl')
    vim.filetype.add({
    extension = {
        swipl = 'swiprolog',
    }
    })
    ```
1. `cd` into your local copy of the repo and run `tree-sitter generate`
1. Open neovim and run `:TSInstall swiprolog` (Make sure you don't have any `.swipl` files open in nvim or you may have trouble on Windows)
1. Open a `.swipl` file and run `:TSEditQuery highlights`, then overwrite the contents with the contents of the highlights query file: `:read ~/tree-sitter-swipl/queries/highlights.scm`
1. You may need to restart nvim at this point but it should be installed.

### Making Changes and Updating Tree-sitter
Say you've made an edit to `grammar.js` and want to see the changes. First of all, you may want to just write and run some tests (add them to `tests/corpus/YOUR_FILE_NAME_HERE.txt`, then run `tree-sitter test`).

But assuming you want to update the highlighting itself, you'll need to do this:

1. Run `tree-sitter generate` if you haven't after making your change.
1. In neovim run `:TSUpdate swiprolog` (If on Windows, make sure you haven't opened any `.swipl` files or you may run into errors (like permission denied, file in use)).
1. If you've made changes to `queries/highlights.scm`, they will not have been copied over into your runtime tree sitter config, so you'll (probably) need to copy those changes over (run `:TSEditQuery highlights` in a `.swipl` file, paste changes).

If anyone knows a more streamlined approach to all this, please let me know.
