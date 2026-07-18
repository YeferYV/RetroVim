 <img width="1366" height="768" alt="screenshot" src="https://github.com/user-attachments/assets/72895442-cdaa-445c-aefe-6c487d89ba13" />

<div align="center">

terax-terminal preconfigured with neovim IDE + yazi builtin plugins + zsh builtin plugins + kanata keyboard layout

---

**[<kbd> <br> Install <br> </kbd>][Install]** 
**[<kbd> <br> Zsh Keymaps <br> </kbd>][Zsh Keymaps]** 
**[<kbd> <br> Keyboard-Layout <br> </kbd>][Keyboard-Layout]** 

[Install]: #installation
[Zsh Keymaps]: #zsh-keymaps
[Keyboard-Layout]: #if-touchcursor-keyboard-layout-started

</div>

---

<details open><summary>Table of Contents</summary>

1. Neovim keymaps
   - [Neovim text object that starts with a/i](#neovim-text-object-that-starts-with-ai)
   - [Neovim text-object/motions/operators that starts with g](#neovim-text-objectmotionsoperators-that-starts-with-g)
2. Terminal
   - [zsh keymaps](#zsh-keymaps)
3. [If Touchcursor Keyboard Layout Started](#if-touchcursor-keyboard-layout-started)
4. Installation
   - [Install](#installation)
5. [Related projects](#related-projects)

</details>

---

## Neovim text object that starts with `a`/`i`

<details open><summary></summary>

|         text-object keymap         | repeat action key | finds and autojumps? | text-object name | description                                                                               | inner / outer                                                                 |
| :--------------------------------: | :---------------: | :------------------: | :--------------- | :---------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------- |
|             `ia`, `aa`             |        `.`        |         yes          | \_argument       | whole argument/parameter of a function                                                    | outer includes comma                                                          |
|             `ib`, `ab`             |        `.`        |         yes          | \_braces         | find the nearest inside of `()` `[]` `{}`                                                 | outer includes braces                                                         |
|             `iB`, `aB`             |        `.`        |         yes          | \_brackets       | find the nearest inside of `{}` `:help iB`                                                | outer includes brackets                                                       |
|             `id`, `ad`             |        `.`        |         yes          | diagnostic       | find errors, warnings, info or hints (only works inside neovim and requires LSP)          | outer same as inner                                                           |
|             `ie`, `ae`             |        `.`        |                      | line             | from start to end of line without beginning whitespaces (line wise)                       | outer includes begining whitespaces                                           |
|             `if`, `af`             |        `.`        |         yes          | \_function_call  | like `function args` but only when a function is called                                   | outer includes the function called                                            |
|             `ih`, `ah`             |        `.`        |         yes          | \_html_attribute | attribute in html/xml like `href="foobar.com"`                                            | inner is only the value inside the quotes trailing comma and space            |
|             `ii`, `ai`             |        `.`        |                      | indent_noblanks  | surrounding lines with same or higher indentation delimited by blanklines                 | outer includes line above                                                     |
|             `iI`, `aI`             |        `.`        |                      | indent           | surrounding lines with same or higher indentation                                         | outer includes line above and below                                           |
|             `ik`, `ak`             |        `.`        |         yes          | \_key            | key of key-value pair, or left side of a assignment                                       | outer includes spaces                                                         |
|             `il`, `al`             |        `.`        |         yes          | +last            | go to last mini.ai text-object (which start with `_`)                                     | requires `i`/`a` example `vilk`                                               |
|             `im`, `am`             |        `.`        |         yes          | \_number         | numbers, similar to `<C-a>`                                                               | inner: only pure digits, outer: number including minus sign and decimal point |
|             `in`, `an`             |        `.`        |         yes          | +next            | go to Next mini.ai text-object (which start with `_`)                                     | requires `i`/`a` example `viNk`                                               |
|             `io`, `ao`             |        `.`        |         yes          | \_whitespaces    | whitespace beetween characters                                                            | outer includes surroundings                                                   |
|             `ip`, `ap`             |        `.`        |                      | paragraph        | blanklines can also be treat as paragraphs when focused on a blankline                    | outer includes below lines                                                    |
|             `iq`, `aq`             |        `.`        |         yes          | \_quotes         | inside of `` ` ` `` or `' '` or `" "`                                                     | outer includes openning and closing quotes                                    |
|             `is`, `as`             |        `.`        |                      | sentence         | sentence delimited by dots of blanklines `:help sentence`                                 | outer includes spaces                                                         |
|             `it`, `at`             |        `.`        |         yes          | \_tag            | inside of a html/jsx tag                                                                  | outer includes openning and closing tags                                      |
|             `iu`, `au`             |        `.`        |                      | \_subword        | like `iw`, but treating `-`, `_`, and `.` as word delimiters _and_ only part of camelCase | outer includes trailing `_`,`-`, or space                                     |
|             `iv`, `av`             |        `.`        |         yes          | \_value          | value of key-value pair, or right side of a assignment                                    | outer includes trailing commas or semicolons or spaces                        |
|             `iw`, `aw`             |        `.`        |                      | word             | from cursor to end of word (delimited by punctuation or space)                            | outer includes whitespace ending                                              |
|             `iW`, `aW`             |        `.`        |                      | WORD             | from cursor to end of WORD (includes punctuation)                                         | outer includes whitespace ending                                              |
|             `ix`, `ax`             |        `.`        |         yes          | \_Hex            | hexadecimal number or color                                                               | outer includes hash `#`                                                       |
|             `i?`, `a?`             |        `.`        |         yes          | \_user_prompt    | will ask you for enter the delimiters of a text object (useful for dot repeteability)     | outer includes surroundings                                                   |
|       `i(`, `i)`, `a(`, `a)`       |        `.`        |         yes          | `(` or `)`       | inside `()`                                                                               | outer includes surroundings                                                   |
|       `i[`, `i]`, `a[`, `a]`       |        `.`        |         yes          | `[` or `]`       | inside `[]`                                                                               | outer includes surroundings                                                   |
|       `i{`, `i}`, `a{`, `a}`       |        `.`        |         yes          | `{` or `}`       | inside `{}`                                                                               | outer includes surroundings                                                   |
|       `i<`, `i>`, `a<`, `a>`       |        `.`        |         yes          | `<` or `>`       | inside `<>`                                                                               | outer includes surroundings                                                   |
|         `` i` ``, `` a` ``         |        `.`        |         yes          | apostrophe       | inside `` ` ` ``                                                                          | outer includes surroundings                                                   |
| `i<punctuation>`, `a<punctuation>` |        `.`        |         yes          | `<punctuation>`  | inside `<punctuation><punctuation>`                                                       | outer includes surroundings                                                   |

</details>

## Neovim text-object/motions/operators that starts with `g`

<details open><summary></summary>

|      keymap       |    mode     | repeat action key |    repeat jump key     | text-object description                                                   | `n`ormal mode = `n` = operator           | `o`perating-pending mode = `o` = text-object | `v`isual mode = `v` = `x` = motion      | examples in normal mode                                                             |
| :---------------: | :---------: | :---------------: | :--------------------: | :------------------------------------------------------------------------ | :--------------------------------------- | :------------------------------------------- | :-------------------------------------- | :---------------------------------------------------------------------------------- |
|    `[c` / `]c`    | `n`,`o`,`x` |        `.`        |                        | previous/next comment                                                     | finds and jumps                          | jumps                                        | uses selection                          | `v]c` selects from cursor position until next comment                               |
|    `[d` / `]d`    | `n`,`o`,`x` |        `.`        |                        | previous/next diagnostic                                                  | finds and jumps                          | jumps                                        | uses selection                          | `v]d` selects from cursor position until next diagnostic                            |
|    `[h` / `]h`    | `n`,`o`,`x` |        `.`        |                        | previous/next git hunk                                                    | finds and jumps                          | jumps                                        | uses selection                          | `v]h` selects from cursor position until next git hunk                              |
|    `[i` / `]i`    | `n`,`o`,`x` |        `.`        |                        | previous/next indent                                                      | finds and jumps                          | jumps                                        | uses selection                          | `v]i` selects from cursor position until next indent                                |
|     `g[`/`g]`     | `n`,`o`,`x` |        `.`        |                        | +prev/+next textobj (only textobj with `_` prefix)                        | followed by text-object                  | finds and jumps                              | uses selection                          | `g]q` next end of quotation                                                         |
|   `g\` / `g\|`    | `n`,`o`,`x` |        `.`        |       `\` / `\|`       | +end/+start of textobj (any inner/outer textobj)                          | followed by text-object                  | finds and jumps                              | uses selection (`\` / `\|` to reselect) | `dg\iq` delete until inner end of quotation (`.` to repeat)                         |
|    `qq ... q`     |   `n`,`x`   |        `.`        |   `\` or `@q` + `@@`   | repeats ... macro                                                         | followed by text-object                  |                                              | selects from cursor position            | `qqviqq` selects quotation (`\` to repeat)                                          |
|    `qw ... q`     |   `n`,`x`   |        `.`        |  `\|` or `@w` + `@@`   | repeats ... macro                                                         | followed by text-object                  |                                              | selects from cursor position            | `qwdiqq` delete inner quotation (`\| ` to repeat)                                   |
|     `g;`/`g,`     |     `n`     |                   |                        | go backward/forward in `:changes`                                         | jumps                                    |                                              |                                         | `g;` go to last change                                                              |
|       `g.`        | `n`,`o`,`x` |                   |                        | jump to last change                                                       | jumps                                    | won't jump                                   | uses selection                          | `vg.` selects from cursor position until last change                                |
|       `ga`        |   `n`,`x`   |                   |                        | +align                                                                    | followed by textobject/motion            |                                              | uses selected region                    | `gaip=` or `vipga=` aligns a paragraph by `=`                                       |
|       `gb`        |   `n`,`x`   |        `.`        |                        | +blackhole register                                                       | followed by textobject/motion            |                                              | deletes selection                       | `gbip` or `vipgb` deletes a paragraph without copying                               |
|       `gB`        |   `n`,`x`   |        `.`        |                        | blackhole linewise                                                        | text-object not required                 |                                              | deletes line                            | `gB.` deletes two lines without saving it in the register                           |
|       `gc`        | `n`,`o`,`x` |        `.`        |                        | +comment (`vgc` in normal mode will select a block comment)               | followed by textobject/motion            | won't jump                                   | uses selection                          | `gcip` or `vipgc` comments a paragraph                                              |
|       `gC`        | `n`,`o`,`x` |        `.`        |                        | block comment (supports selection `vgC` or just `gC`)                     | select text-object under cursor          | won't jump                                   | reselects                               | `vgC` selects current block of comment                                              |
|       `gd`        |     `n`     |                   |                        | go to definition                                                          | jumps                                    |                                              |                                         | `gd` go to definition of word under cursor                                          |
|       `gD`        |     `x`     |                   |                        | git diff/hunk (vscode selects from cursor position to end of diff)        |                                          | won't jump                                   | reselects                               | `vgD` selects modified code                                                         |
|     `ge`/`gE`     | `n`,`o`,`x` |                   |                        | previous end of word/WORD (`WORD` omits punctuation)                      | jumps                                    | uses cursor position                         | uses selection                          | `vge` selects from cursor position until previous end of word                       |
|       `gf`        |   `n`,`x`   |                   |                        | go to file under cursor                                                   | jumps                                    |                                              | uses selection                          | `gf` open in a tab the path under cursor                                            |
|     `gg`/`G`      | `n`,`o`,`x` |        `.`        |                        | first/last line                                                           | jumps                                    | uses cursor position                         | uses selection                          | `vgg` selects until first line                                                      |
|       `gi`        |   `n`,`x`   |                   |                        | last position of cursor in insert mode                                    | finds and jumps                          |                                              | uses selection                          | `vgi` selects until last insertion                                                  |
|     `gj`/`gk`     | `n`,`o`,`x` |        `.`        |                        | go down/up when wrapped                                                   | jumps                                    | uses cursor position                         | uses selection                          | `vgj` selects one line down                                                         |
|       `gJ`        |   `n`,`x`   |        `.`        |                        | join below lines                                                          | joins                                    |                                              | uses selection                          | `vgJ` joins selected lines into one line                                            |
|       `gm`        |   `n`,`x`   |                   |                        | +multiply (duplicate text) operator                                       |                                          | won't jump                                   | uses selection                          | `gmap` or `vapgm` duplicates paragraph without replacing clipboard                  |
|       `gM`        |   `n`,`x`   |                   |                        | go to middle line                                                         | jumps                                    |                                              | uses selection                          | `vgM` selects until middle of the line                                              |
|     `gp`/`gn`     | `n`,`o`,`x` |        `.`        |                        | prev/next find                                                            | text-object not required                 | finds and jumps                              | uses selection                          | `cgn???` replaces last search with `???` forwardly                                  |
|       `go`        |     `x`     |                   |                        | jsx/tsx comment (only inside neovim)                                      |                                          |                                              | uses selection                          | `vipgt` comments out a paragraph with `{/* */}`                                     |
|       `gq`        |   `n`,`x`   |        `.`        |                        | +format selection/comments 80chars (LSP overrides it)                     | requires a textobject                    |                                              | applies to selection                    | `gqip` or `vipgq` formats a paragraph                                               |
|       `gr`        |   `n`,`x`   |        `.`        |                        | +replace (with register) operator                                         | followed by text-object/motion           |                                              | applies to selection                    | `griw` or `viwgr` replaces word with register (yanked text)                         |
|       `gs`        |   `n`,`x`   |        `.`        |                        | +sort Operator                                                            | followed by text-object/motion           |                                              | uses selection                          | `gsip` or `vipgs` sorts a paragraph                                                 |
|       `gS`        |   `n`,`x`   |        `.`        |                        | split/join arguments                                                      | toggles inside `{}`,`[]`,`()`            |                                              | followed by operator                    | `vipgS` joins selected lines in one line                                            |
|     `gu`/`gU`     |   `n`,`x`   |        `.`        |                        | +to lowercase/uppercase                                                   | requires a text-object                   |                                              | applies to selection                    | `gUiw` (neovim and cvim only) or `viwgU` uppercase a word                           |
|       `gv`        |   `n`,`x`   |                   |                        | last selected                                                             | finds and jumps                          |                                              | reselects                               | `vgv` selects last selection                                                        |
|       `gw`        |   `n`,`x`   |        `.`        |                        | split/join comments/lines 80chars (keeps cursor position)                 | requires a text-object                   |                                              | applies to selection                    | `gwip` or `vipgw` split/join a paragraph limited by 80 characters                   |
|       `gx`        |   `n`,`x`   |        `.`        |                        | +exchange (text) Operator                                                 | followed by text-object/motion           |                                              | uses selection                          | `gxiw` or `viwgx` exchanges word with another `gxiw` or `viwgx` or `.`              |
|     `gy`/`gY`     |     `n`     |        `.`        |                        | redo register (dot to paste forward/bacward)                              | paste                                    |                                              |                                         | `gy.....` paste deleted lines by history                                            |
|     `g-`/`g+`     |   `n`,`x`   |        `.`        |                        | decrement/increment number                                                | selects number under cursor              |                                              | uses selected number                    | `g+..` or `3g+` increments by 3                                                     |
| `g<Up>`/`g<Down>` |   `n`,`x`   |                   |                        | numbers ascending/descending                                              | selects number under cursor              |                                              | uses selected number                    | `g<Up>` increases selected numbers ascendingly                                      |
|        `=`        |   `n`,`x`   |        `.`        |                        | +autoindent                                                               | followed by text-object                  |                                              | uses selection                          | `==` autoindents line                                                               |
|      `<`/`>`      |   `n`,`x`   |        `.`        |                        | +indent left/right                                                        | followed by text-object                  |                                              | uses selection                          | `<<` indents to left a line                                                         |
|      `0`/`$`      | `n`,`o`,`x` |        `.`        |                        | start/end of line                                                         | jumps                                    |                                              | uses selection                          | `d$j.` deletes two end-of-lines                                                     |
|        `^`        | `n`,`o`,`x` |        `.`        |                        | start of line (non-blankline)                                             | jumps                                    |                                              | uses selection                          | `d^` deletes until start of line (after whitespace)                                 |
|        `%`        | `n`,`o`,`x` |                   |                        | matching character: '()', '{}', '[]'                                      | finds and jumps                          |                                              | finds and jumps                         | `d%` deletes until bracket                                                          |
|      `(`/`)`      | `n`,`o`,`x` |        `.`        |                        | prev/next sentence                                                        | jumps                                    |                                              | uses selection                          | `d(.` deletes until start of sentence (two times)                                   |
|      `{`/`}`      | `n`,`o`,`x` |        `.`        |                        | prev/next empty line (before a paragraph)                                 | jumps                                    |                                              | uses selection                          | `d{.` deletes until next empty line (two times)                                     |
|     `[[`/`]]`     | `n`,`o`,`x` |        `.`        |                        | prev/next section                                                         | jumps                                    |                                              | uses selection                          | `d[[` deletes until start of section                                                |
|      `b`/`w`      | `n`,`o`,`x` |        `.`        |                        | prev/next word                                                            | jumps                                    |                                              | uses selection                          | `db` deletes until start of word                                                    |
|      `B`/`W`      | `n`,`o`,`x` |        `.`        |                        | prev/next WORD                                                            | jumps                                    |                                              | uses selection                          | `dW.` deletes 2 WORDS                                                               |
|      `e`/`E`      | `n`,`o`,`x` |        `.`        |                        | end of word/WORD                                                          | jumps                                    |                                              | uses selection                          | `de` deletes until end of word                                                      |
|        `/`        | `n`,`o`,`x` |        `.`        |                        | search with labels like [flash.nvim](https://github.com/folke/flash.nvim) | jumps                                    | finds and jumps                              | uses selection                          | `d/` then `search` then `label` to delete `c/` to change `v/` to select `/` to jump |
|      `f`/`F`      | `n`,`o`,`x` |        `.`        | `;`forward `,`backward | move to next/prev char (`f` forward, `F` backward for vscode-neovim)      | jumps                                    |                                              | uses selection                          | `df,` deletes until a next `,`                                                      |
|      `t`/`T`      | `n`,`o`,`x` |        `.`        | `;`forward `,`backward | move before next/prev char (`t` forward, `T` backward for vscode-neovim)  | jumps                                    |                                              | uses selection                          | `dt,` deletes before next `,`                                                       |
|        `s`        |   `n`,`x`   |        `.`        |                        | +surround (followed by a=add, d=delete, r=replace)                        | followed by textobject/motion (only add) |                                              | uses selection (only add)               | `saiw"` or `viwsa"` adds `"` to word, `sd"` deletes `"`, `sr"'` replaces `"`        |
|        `U`        |   `n`,`x`   |                   |          `U`           | whichkey repeater (inside neovim repeats `:<command>` like macros)        |                                          |                                              |                                         | `<s-space>gjUUU` repeats next-git-change (`:normal A,jkj` end of line comma)        |
|        `Y`        |   `n`,`x`   |                   |                        | yank until end of line                                                    |                                          |                                              | uses selection                          | `v^Y` yanks line                                                                    |
| `<space><space>p` |   `n`,`x`   |        `.`        |                        | Paste after (secondary clipboard)                                         |                                          |                                              | uses selection                          | `viw<space><space>p` replaces word with a second clipboard                          |
| `<space><space>P` |   `n`,`x`   |        `.`        |                        | Paste before (secondary clipboard)                                        |                                          |                                              | uses selection                          | `viw<space><space>P` replaces word with a second clipboard                          |
| `<space><space>y` |   `n`,`x`   |                   |                        | yank (secondary clipboard)                                                |                                          |                                              | uses selection                          | `viw<space><space>y` yanks word using the second clipboard                          |
| `<space><space>Y` |   `n`,`x`   |                   |                        | yank until end of line (secondary clipboard)                              |                                          |                                              | uses selection                          | `v<space><space>Y` yanks until end of line using the second clipboard               |

</details>

---

## zsh keymaps

<details open><summary></summary>

|       keymap        | description                                                |
| :-----------------: | :--------------------------------------------------------- |
|       `<tab>`       | show (dash/path) options or complete path                  |
|    `<tab><tab>`     | enter completion menu                                      |
|    `<esc><esc>`     | tmux-copy-mode-like / normal-mode (inside neovim terminal) |
|   `shift+escape`    | tmux-copy-mode-like / normal-mode (inside neovim terminal) |
|    `nvim<enter>`    | open retronvim's neovim IDE (`<space>` to open whichkey)   |
|     `y<enter>`      | open yazi (changes directory on exit)                      |
| `alt+o` or `<esc>o` | open yazi (even while writing commands)                    |
| `alt+h` or `<esc>`  | enter vim-mode                                             |
|       `alt+l`       | complete inline/ghost suggestion and enter vim-mode        |
|       `alt+j`       | prev shell history and enter vim-mode                      |
|       `alt+k`       | next shell history and enter vim-mode                      |
|        `Up`         | prev shell history                                         |
|       `Down`        | next shell history                                         |
|      `ctrl+r`       | search history with fzf                                    |
|      `ctrl+l`       | clear screen                                               |
|    `ctrl+alt+l`     | clear screen (inside neovim terminal or vscode terminal)   |
|      `ctrl+d`       | exit signal                                                |
|      `ctrl+c`       | cancel signal                                              |

</details>

---

## If Touchcursor Keyboard Layout Started

<details open><summary></summary>

**layer qwerty**

```
@grl 1    2    3    4    5    6    7    8    9    0    -    =    @bsp
tab  q    w    @e   r    t    y    u    i    o    p    [    ]    ret
@cap a    @s   @d   f    g    @h   @j   @k   @l   @;   '    \
lsft ret  z    x    c    v    b    n    m    ,    .    /    rsft
lctl lmet @alt           @spc           @sft rmet rctl
```

**layer touchcursor** (press and hold space to enter the layer)

```
_    f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  _
_    @M↑  del  @m↑  @clr @m🡠  _    _    _    _    _    _    _    _
_    @M↓  @bsp @m↓  spc  @m🡪  @🡠   @↓   @↑   @🡪   @yaz _    _
_    _    _    _    caps @¿   @ñ   pgup home end  pgdn _    _
_    _    _              _              _    _    _
```

| key  | description                                                                               |          example / keymap          |
| :--: | :---------------------------------------------------------------------------------------- | :--------------------------------: |
| @grl | tap: backtick/grave, hold and press `1` = qwerty layer, hold and press `2` = dvorak layer |         `` `+2 = dvorak ``         |
| @cap | tap for escape, hold for LeftCtrl                                                         |          `cap+l = ctrl+l`          |
| @sft | tap for backspace, hold for LeftShift                                                     |         `RAlt+l = shift+l`         |
| @alt | tap for middle click, hold for LeftAlt                                                    |         `LAlt+l = LAlt+l`          |
| @spc | tap for space, hold for touchcursor layer, release for qwerty layer                       | `space+jj = DownArrow + DownArrow` |
|  @;  | tap for semicolon, hold for ctrl                                                          | `;+click = OpenInNewTab (chrome)`  |
| @clr | clear screen on any shell                                                                 |             `space+r`              |
|  @¿  | unicode ¿                                                                                 |             `space+v`              |
|  @ñ  | unicode ñ                                                                                 |             `space+b`              |
| @m🡠  | mouse scrolling left                                                                      |             `space+t`              |
| @m🡪  | mouse scrolling right                                                                     |             `space+g`              |
| @m↑  | mouse scrolling up                                                                        |             `space+e`              |
| @m↓  | mouse scrolling down                                                                      |             `space+d`              |
| @M↑  | mouse fast scrolling up                                                                   |             `space+q`              |
| @M↓  | mouse fast scrolling down                                                                 |             `space+a`              |
| spc  | space key                                                                                 |             `space+f`              |
| bspc | backspace key                                                                             |             `space+s`              |
| home | home key                                                                                  |             `space+m`              |
| end  | end key                                                                                   |             `space+,`              |
| pgup | pageup key                                                                                |             `space+n`              |
| pgdn | pagedown key                                                                              |             `space+.`              |
|  @🡠  | left arrow key                                                                            |             `space+h`              |
|  @↓  | down arrow key                                                                            |             `space+j`              |
|  @↑  | up arrow key                                                                              |             `space+k`              |
|  @🡪  | right arrow key                                                                           |             `space+l`              |
| caps | toggles capslock                                                                          |             `space+c`              |

</details>

---

## Installation

<details open><summary></summary>

**Install RetroVim on any terminal or shell**

- Powershell (windows):

  ```bash
  irm pixi.sh/install.ps1 | iex
  pixi g install retrovim -c retronvim -c conda-forge
  ```

- SSH/Bash/Zsh (linux/macos):

  ```bash
  sh <(curl https://pkgx.sh) pixi g install retrovim -c retronvim -c conda-forge --with pixi
  ```

**Plugins**

- RetroVim.conda is shipped with
  - [`bat`](https://github.com/sharkdp/bat)
  - [`eza`](https://github.com/eza-community/eza)
  - [`firacode_nerd_font`](https://github.com/ryanoasis/nerd-fonts)
  - [`fd`](https://github.com/sharkdp/fd)
  - [`fzf`](https://github.com/junegunn/fzf)
  - [`git`](https://github.com/git-for-windows/git)
  - [`kanata`](https://github.com/jtroo/kanata)
  - [`lazygit`](https://github.com/jesseduffield/lazygit)
  - [`neovim`](https://neovim.io)
  - [`pixi`](https://github.com/prefix-dev/pixi)
  - [`ripgrep`](https://github.com/BurntSushi/ripgrep)
  - [`starship`](https://github.com/starship/starship)
  - [`terax`](https://github.com/crynta/terax-ai)
  - [`yazi`](https://github.com/sxyazi/yazi)
  - [`zerobrew`](https://github.com/lucasgelfond/zerobrew)
  - [`zsh`](https://github.com/zsh-users/zsh)
  - [`zsh-patina`](https://github.com/michel-kraemer/zsh-patina)
  - [`7zip`](https://github.com/ip7z/7zip)

- RetroVim/nvim comes with an installer for
  - [`mini.nvim`](https://github.com/echasnovski/mini.nvim) (shipped as git-submodule)
  - [`copilot`](https://github.com/github/copilot-language-server-release) (shipped with sidekick.nvim)
  - [`flash.nvim`](https://github.com/folke/flash.nvim)
  - [`neotype`](https://github.com/rodolfo-arg/neotype)
  - [`nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig)
  - [`sidekick.nvim`](https://github.com/folke/sidekick.nvim) (free copilot nes + agents integration like gemini-cli)
  - [`supermaven`](https://github.com/supermaven-inc/supermaven-nvim) (free copilot)

- RetroVim/nvim searches for vscode extensions's snippets in `~/.*/extensions/*/snippets/*code-snippets`
  (alphabetically first `~/.antigravity` otherwise `~/.cursor` otherwise `~/.vscode` otherwise `~/.windsurf`)
  and automatically adds them to `mini.completion`

  - if you see: `No contains a valid JSON object` then to fix it use biome linter usually it is extras commas or comments
  - if you see: `File is absent or not readable` then delete the file to make `mini.snippet` work

- `Touchcursor Keyboard Layout` on `MacOs` requires `zb install karabiner`

- `terax` on `archlinux` requires `pacman -S webkit2gtk-4.1`

- `terax` on `debian` requires `apt install webkit2gtk-4.1-dev`

- `terax` on `linux` requires `chsh --shell /bin/zsh` (sets zsh as default shell)

- `terax` requires the setting `Font family: FiraCode Nerd Font` for icons support (`pixi exec --channel retronvim -- firacode-nerdfont-installer` to install firacode font)

</details>

## Related projects

<details open><summary></summary>

- [yeferyv/RetroNvim](https://github.com/yeferyv/retronvim)
  vscode extension with minimal whichkey, lazyvim, terax, yazi, zsh and kanata setup

- [yeferyv/dotfiles](https://github.com/yeferyv/dotfiles)
  retronvim + [hyprland](https://hypr.land) setup

- [yazelix](https://github.com/luccahuguet/yazelix)
  terminal IDE

- [nativevim](https://github.com/boltlessengineer/NativeVim)
  neovim config without plugins

- [lazyvim](https://github.com/lazyvim/lazyvim)
  neovim IDE using 32 plugins (with copilot, agents, text-objects, whichkey ...)

- [binvim](https://github.com/bgunnarsson/binvim/)
  neovim IDE written in rust (with copilot, agents, text-objects, whichkey ...)

- [evil-helix](https://github.com/usagi-flow/evil-helix)
  helix fork with vim keybindings, text-objects, whichkey ... (no dot-to-repeat)

- [reovim](https://github.com/ds1sqe/reovim)
  neovim IDE written in rust (no copilot, no agents)

- [red](https://github.com/codersauce/red)
  neovim IDE written in rust (no copilot, no agents)

- [fresh](https://github.com/sinelaw/fresh)
  neovim IDE written in rust (no copilot, no agents, no text-objects, no whichkey)

- [termide](https://github.com/termide/termide)
  neovim IDE written in rust (no copilot, no agents, no text-objects, no whichkey)

</details>
