# PSL (IEEE 1850) Syntax — VS Code starter

A minimal TextMate grammar for IEEE 1850 Property Specification Language. Two modes:

1. **Standalone** — `.psl` and `.vunit` files are highlighted directly.
2. **Injected into VHDL** — inside any file VS Code recognises as VHDL (`source.vhdl`, which is what VHDL-LS / `hbohlin.vhdl-ls` registers), lines starting with `-- psl` are re-tokenized as PSL while ordinary `--` comments stay as plain VHDL comments.

Highlights:

- Verification directives: `assert`, `assume`, `cover`, `restrict`, `fairness`, `strong`
- Verification units: `vunit` / `vmode` / `vprop` (and their `end…` forms)
- Property/sequence declarations and `default clock`
- FL temporal operators: `always`, `never`, `eventually!`, `next` family, `until` family, `before` family, `abort` family
- SERE brackets: `[*]`, `[+]`, `[*n]`, `[*n:m]`, `[=n]`, `[->n]`
- SERE composition: `;` `:` `|` `&&` and `within`
- Implication: `|->`, `|=>`, `->`, `<->`
- Logical: `and`, `or`, `not`, `xor`, `nand`, `nor`, `xnor`
- Types: `boolean`, `bit`, `bitvector`, `numeric`, `string`, `integer`, `real`
- Numbers (decimal, based `16#FF#`, bit strings `b"1010"`, `x"FF"`)

## Install (local, no marketplace publish)

Drop the whole `psl-vscode` folder into your user extensions directory:

| OS              | Path                                          |
|-----------------|-----------------------------------------------|
| Linux / macOS   | `~/.vscode/extensions/psl-vscode/`            |
| Windows         | `%USERPROFILE%\.vscode\extensions\psl-vscode\` |

Then reload VS Code (`Ctrl+Shift+P` → *Developer: Reload Window*). Open `example.psl` for the standalone view and `example.vhd` to see the VHDL injection at work — the `-- psl …` lines should color their keywords distinctly while the surrounding `--` lines stay plain.

To inspect what scopes are matching, run *Developer: Inspect Editor Tokens and Scopes*.

## How the VHDL injection works

`syntaxes/psl-injection-vhdl.tmLanguage.json` declares `injectTo: ["source.vhdl"]` and uses `injectionSelector: "L:source.vhdl"`. The `L:` ("left", high-priority) prefix lets the injection's tokens win over VHDL-LS's host comment grammar inside `-- psl …` regions, so PSL keywords get their own scopes instead of being uniformly colored as a comment. Each pattern inside the `begin`/`end` rule is just `include: "source.psl#…"`, reusing the standalone grammar's repository — no rule duplication.

### Limitations

- **Single-line directives only.** A `-- psl` line is highlighted from the marker to end-of-line. Multi-line directives where only the first line carries the `psl` marker (e.g. an `assert` whose expression continues on subsequent `--` lines) won't have their continuation lines re-highlighted; those will look like regular VHDL comments. Repeating `-- psl` on each continuation line is the simple workaround and a fairly common convention.
- **VHDL-2008 `/* psl … */` block markers are not handled.** Easy to add if you need them — mirror the existing rule with `begin: "/\\*\\s*psl\\b"` and `end: "\\*/"`.
- **No semantic checks.** Pure regex tokenization, so `assert` written as a normal VHDL identifier inside a `-- psl` line would still be colored as a directive. The standalone PSL grammar has the same limitation. For real analysis you'd need a language server.

## Adapting to other VHDL extensions

If you use a different VHDL extension, check its `package.json` for `scopeName`. Most use `source.vhdl`, but a few (e.g. some forks) ship with their own scope names. Change `injectTo` and `injectionSelector` in the injection grammar to match.

For Verilog/SystemVerilog flavor PSL (using `// psl` and case-sensitive keywords): copy `psl-injection-vhdl.tmLanguage.json` to a Verilog variant, change `injectTo` to `source.verilog` (or `source.systemverilog`), change the `begin` regex to `(?i)(//)\\s*(psl)\\b\\s*`, and consider dropping the `(?i)` from the keyword patterns in the standalone grammar if you want strict case-sensitive matching.

## License

Public domain / CC0 — do whatever.
