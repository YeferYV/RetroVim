--- ╭─────────╮
--- │ Plugins │
--- ╰─────────╯

vim.env.CONDA_PREFIX = vim.env.CONDA_PREFIX or (vim.env.HOME .. '/.pixi/envs/retrovim')
vim.env.PNPM_HOME    = vim.env.PNPM_HOME or (vim.env.HOME .. '/.local/share/pnpm')
vim.env.PATH         = vim.env.PATH .. (vim.env.APPDATA and ';' or ':') .. vim.env.PNPM_HOME .. '/bin'
vim.env.PATH         = vim.env.PATH .. (vim.env.APPDATA and ';' or ':') .. vim.env.HOME .. '/.pixi/bin'

local vim            = vim --- lsp warnings
local mini_path      = vim.env.CONDA_PREFIX .. '/opt/retrovim/nvim/plugins/mini.nvim'

if not vim.loop.fs_stat(mini_path) then
  vim.pack.add({ { src = 'https://github.com/nvim-mini/mini.nvim', version = 'af5f75c9ce572a4d1f0c77d6fb4ea764d16c1b3c' } })
end

vim.opt.rtp:prepend(mini_path)
vim.opt.rtp:append(vim.fn.expand(vim.fn.stdpath('data') .. '/site/pack/core/opt/*', 0, 1))

local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local _, vscode = pcall(require, "vscode-neovim")
vim.g.mapleader = " " --- <leader> key

------------------------------------------------------------------------------------------------------------------------

if not vim.g.vscode then
  vim.lsp.inline_completion.enable()

  map({ 'i' }, '<a-l>', function() vim.lsp.inline_completion.get() end, { desc = ' accept suggestion' })
  map({ 'i' }, '<a-[>', function() vim.lsp.inline_completion.select({ count = -1 }) end, { desc = ' prev suggestion' })
  map({ 'i' }, '<a-]>', function() vim.lsp.inline_completion.select({ count = 1 }) end, { desc = ' next suggestion' })
  map({ 'i', 'n', 'x' }, '<a-;>', function() require("sidekick").nes_jump_or_apply() end, { desc = ' nes apply' }) --- <m-;> doesn't work with pum
  map({ 'i', 'n', 'x' }, '<a-,>', function() require("sidekick.nes").update() end, { desc = ' nes update' })
  map({ 'i', 'n', 'x' }, "<a-'>", function() require("sidekick.nes").clear() end, { desc = ' nes clear' })
  map({ 'i', 'n', 'x' }, '<leader>lg', "<cmd>Sidekick cli toggle name=gemini<cr>", { desc = '󰫣 Gemini cli' })
  map({ 'i', 'n', 'x' }, '<leader>lG', "<cmd>Sidekick cli prompt<cr>", { desc = '󰫣 Gemini prompt' })

  pcall(function() require("sidekick").setup({}) end)
end

------------------------------------------------------------------------------------------------------------------------

pcall(function() require("flash").setup({ modes = { search = { enabled = true } } }) end)

------------------------------------------------------------------------------------------------------------------------

if not vim.g.vscode then
  local ok, supermaven = pcall(require, "supermaven-nvim")

  if ok then
    vim.lsp.inline_completion.enable(false) -- disable copilot inline suggestion
    supermaven.setup({ disable_keymaps = true })
    map("i", "<A-l>", function() require("supermaven-nvim.completion_preview").on_accept_suggestion() end)
    map("i", "<A-k>", function() require("supermaven-nvim.completion_preview").on_dispose_inlay() end) -- clear suggestion
    map("i", "<A-j>", function() require("supermaven-nvim.completion_preview").on_accept_suggestion_word() end)
  end
end

--- ╭──────╮
--- │ Opts │
--- ╰──────╯

vim.opt.backupcopy =
"yes"                             --- fixes `next dev --turbopack` file change detection, see `:h file-watcher` and https://github.com/neovim/neovim/issues/1380
vim.opt.clipboard = "unnamedplus" --- allows neovim to access the system clipboard
vim.opt.expandtab = true          --- convert tabs to spaces
vim.opt.hlsearch = true           --- highlight all matches on previous search pattern
vim.opt.ignorecase = true         --- ignore case in search patterns
vim.opt.shiftwidth = 2            --- the number of spaces inserted for each indentation
vim.opt.smartcase = true          --- smart case
vim.opt.splitbelow = true         --- force all horizontal splits to go below current window
vim.opt.splitright = true         --- force all vertical splits to go to the right of current window
vim.opt.shellcmdflag = '-c'       --- https://github.com/neovim/neovim/issues/16957
vim.opt.shellxquote = ''          --- https://github.com/neovim/neovim/issues/16957
vim.opt.tabstop = 2               --- insert 2 spaces for a tab
vim.opt.termguicolors = true      --- fixes colorscheme after :restart https://github.com/neovim/neovim/issues/38545
vim.opt.timeoutlen = 500          --- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.winborder = 'rounded'     --- MiniCompletion's info and signature border
vim.opt.wrap = false              --- display lines as one long line
vim.opt.list = true               --- Enables the visibility of listchars globally
vim.opt.listchars = {
  tab = "▏ ",
  multispace = " ", --- Keeps non-leading consecutive spaces clean
  leadmultispace = "▏ ", --- Matches your indent size (1 character + spaces)
  trail = " ",
}

if not vim.g.vscode then
  vim.opt.pumborder = 'rounded'               --- enable mini.completion border
  vim.opt.cmdheight = 0                       --- more space in the neovim command line for displaying messages
  vim.opt.laststatus = 3                      --- laststatus=3 global status line (line between splits)
  vim.opt.number = true                       --- set numbered lines
  vim.opt.scrolloff = 3                       --- vertical scrolloff
  vim.opt.sidescrolloff = 3                   --- horizontal scrolloff
  vim.opt.virtualedit = "all"                 --- allow cursor bypass end of line
  vim.o.foldcolumn = '1'                      --- if '1' will show clickable fold signs
  vim.o.foldlevel = 99                        --- Disable folding at startup
  vim.o.foldmethod = "expr"                   --- expr = specify an expression to define folds
  vim.o.foldexpr = 'v:lua.vim.lsp.foldexpr()' --- if folding using treesitter then 'v:lua.vim.treesitter.foldexpr()'
  vim.o.fillchars = [[eob: ,fold: ,foldinner: ,foldopen:,foldsep: ,foldclose:]]
  vim.g.netrw_banner = 0                      -- Hide the massive top banner
  vim.g.netrw_liststyle = 3                   -- Use tree-style view instead of a flat list
  vim.g.netrw_browse_split = 4                -- Open files in a new vertical split on the right
  vim.g.netrw_winsize = 18                    -- Set the width of the netrw split window (percentage)
  vim.g.netrw_preview = 1                     -- open in a split window
  vim.g.netrw_list_hide =                     -- absolute path not supported only relative path works
      vim.cmd.packadd('netrw') and
      vim.fn["netrw_gitignore#Hide"]()
      .. ",.git"
  -- vim.g.netrw_localcopydircmd = 'cp -r'    -- Change copy command to support recursive copying
  -- vim.g.netrw_keepdir = 0                  -- don't close netrw after picking a file
  -- vim.g.netrw_altv = 1                     -- open file to the right
  -- vim.g.netrw_special_syntax = 0           -- desactiva los colores por defecto de netrw
end

--- ╭──────────────╮
--- │ Autocommands │
--- ╰──────────────╯

local M = {}
local mini_icons = require('mini.icons')
local netrw_ns = vim.api.nvim_create_namespace('netrw_icons')

local function set_netrw_icons(ev)
  -- https://www.reddit.com/r/neovim/comments/lovv9i/how_can_i_stop_netrw_creating_no_name_buffers_on_toggle
  -- vim.bo.bufhidden = 'hide' --- if 'wipe' then vim.cmd.buffer() can't find ev.buf

  M.netrw_buf = ev.buf
  autocmd('WinClosed', { buffer = ev.buf, once = true, callback = function() M.netrw_buf = nil end })

  map("n", "l", "<cr>", { buffer = ev.buf, remap = true })
  map("n", "h", "<cr>", { buffer = ev.buf, remap = true })
  map("n", "q", "<cmd>quit<cr>", { buffer = ev.buf, remap = true })
  map("n", "<c-l>", "<cmd>wincmd l<cr>", { buffer = ev.buf, remap = true })

  vim.api.nvim_buf_clear_namespace(0, netrw_ns, 0, -1)

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  for i, line in ipairs(lines) do
    -- overlay tree bar characters
    local col = 0
    while true do
      local s = line:find('|', col + 1, true)
      if not s then break end
      vim.api.nvim_buf_set_extmark(0, netrw_ns, i - 1, s - 1, {
        virt_text = { { '│', 'Comment' } },
        virt_text_pos = 'overlay',
      })
      col = s
    end

    -- netrw style 3: "| | filename" or "| | dir/"
    local name = line:match('^.*|%s+(.+)$')

    if name then
      local is_dir = name:sub(-1) == '/'
      local icon, hl = mini_icons.get('file', name)

      if is_dir then
        icon, hl = mini_icons.get('directory', name)
        vim.api.nvim_buf_set_extmark(0, netrw_ns, i - 1, #line - 1, {
          virt_text = { { ' ', hl } },
          virt_text_pos = 'overlay'
        })
      end

      if icon then
        vim.api.nvim_buf_set_extmark(0, netrw_ns, i - 1, #line - #name - 2, {
          virt_text = { { icon .. ' ', hl } },
          virt_text_pos = 'overlay'
        })
      end
    end
  end
end

--- set mini.icons when opening netrw
autocmd('FileType', { pattern = 'netrw', callback = set_netrw_icons })

--- stop comment prefix on new lines
autocmd({ "BufEnter" }, { command = "set formatoptions-=cro" })

if not vim.g.vscode then
  --- briefly highlight yanked text
  autocmd("TextYankPost", { callback = function() vim.highlight.on_yank({ higroup = "Visual", timeout = 200 }) end })

  autocmd({ "BufWinEnter" }, { pattern = "*.code-snippets", command = "set ft=json" })

  --- right click menu
  vim.cmd [[ anoremenu PopUp.Quit <cmd>quit!<cr> ]]

  autocmd({ "TermEnter", "TermOpen" }, { command = "startinsert" })

  --- hide bufferline if `nvim -cterm` or `nvim +term`
  autocmd("TermLeave",
    { command = [[lua vim.schedule(function() return vim.fn.bufname() == "" and vim.cmd.quit() end)]] })
end

--- ╭──────╮
--- │ Mini │
--- ╰──────╯

local gen_ai_spec = require('mini.extra').gen_ai_spec
local mini_clue = require("mini.clue")

require("mini.ai").setup({
  custom_textobjects = {
    d = gen_ai_spec.diagnostic(),                                                                                           --- diagnostic textobj
    e = gen_ai_spec.line(),                                                                                                 --- line textobj
    I = gen_ai_spec.indent(),                                                                                               --- indent textobj including blank-lines
    h = { { "<(%w-)%f[^<%w][^<>]->.-</%1>" }, { "%f[%w]%w+=()%b{}()", '%f[%w]%w+=()%b""()', "%f[%w]%w+=()%b''()" } },       --- html attribute textobj
    k = { { "\n.-[=:]", "^.-[=:]" }, "^%s*()().-()%s-()=?[!=<>\\+-\\*]?[=:]" },                                             --- key textobj
    v = { { "[=:]()%s*().-%s*()[;,]()", "[=:]=?()%s*().*()().$" } },                                                        --- value textobj
    m = gen_ai_spec.number(),                                                                                               --- number(inside string) textobj { '[-+]?()%f[%d]%d+()%.?%d*' }
    x = { '#()%x%x%x%x%x%x()' },                                                                                            --- hexadecimal textobj
    o = { "%S()%s+()%S" },                                                                                                  --- whitespace textobj
    u = { { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]', }, '^().*()$' }, --- sub word textobj https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-ai.txt

    --> https://thevaluable.dev/vim-create-text-objects
    --- select indent by the same or mayor level delimited by blank-lines
    i = function()
      local start_indent = vim.fn.indent(vim.fn.line('.'))
      local prev_line    = vim.fn.line('.') - 1
      local next_line    = vim.fn.line('.') + 1

      while vim.fn.indent(prev_line) >= start_indent do prev_line = prev_line - 1 end
      while vim.fn.indent(next_line) >= start_indent do next_line = next_line + 1 end

      return { from = { line = prev_line + 1, col = 1 }, to = { line = next_line - 1, col = 100 }, vis_mode = 'V' }
    end,
  },
  n_lines = 500, --- search range and required by functions less than 500 LOC
})

require('mini.align').setup()
require('mini.bracketed').setup({ undo = { suffix = '' } })
require('mini.jump').setup( --[[{ repeat_jump = ';' }]]) --- ; by default
require('mini.operators').setup()
require('mini.splitjoin').setup()
require('mini.surround').setup()
require('mini.trailspace').setup()

if not vim.g.vscode then
  require('mini.clue').setup({
    triggers = {
      { keys = 'a',        mode = { 'o', 'x' } },
      { keys = 'i',        mode = { 'o', 'x' } },
      { keys = 'g',        mode = { 'o', 'x', 'n' } },
      { keys = 'z',        mode = { 'x', 'n' } },
      { keys = "'",        mode = { 'x', 'n' } },
      { keys = '"',        mode = { 'x', 'n' } },
      { keys = '`',        mode = { 'x', 'n' } },
      { keys = '[',        mode = { 'x', 'n' } },
      { keys = ']',        mode = { 'x', 'n' } },
      { keys = '<c-r>',    mode = { 'i', 'c' } },
      { keys = '<C-w>',    mode = { 'n' } },
      { keys = '<C-x>',    mode = { 'i' } },
      { keys = '<Leader>', mode = { 'x', 'n' } },
    },
    clues = {
      mini_clue.gen_clues.builtin_completion(),
      mini_clue.gen_clues.g(),
      mini_clue.gen_clues.marks(),
      mini_clue.gen_clues.registers(),
      mini_clue.gen_clues.windows(),
      mini_clue.gen_clues.z(),
      { desc = "argument",    keys = "aa", mode = { "o", "x" } },
      { desc = "argument",    keys = "ia", mode = { "o", "x" } },
      { desc = "braces",      keys = "ab", mode = { "o", "x" } },
      { desc = "braces",      keys = "ib", mode = { "o", "x" } },
      { desc = "diagnostic",  keys = "ad", mode = { "o", "x" } },
      { desc = "dignostic",   keys = "id", mode = { "o", "x" } },
      { desc = "line",        keys = "ae", mode = { "o", "x" } },
      { desc = "line",        keys = "ie", mode = { "o", "x" } },
      { desc = "func_call",   keys = "af", mode = { "o", "x" } },
      { desc = "func_call",   keys = "if", mode = { "o", "x" } },
      { desc = "html_attrib", keys = "ah", mode = { "o", "x" } },
      { desc = "html_attrib", keys = "ih", mode = { "o", "x" } },
      { desc = "indent",      keys = "aI", mode = { "o", "x" } },
      { desc = "indent",      keys = "iI", mode = { "o", "x" } },
      { desc = "key",         keys = "ak", mode = { "o", "x" } },
      { desc = "key",         keys = "ik", mode = { "o", "x" } },
      { desc = "number",      keys = "am", mode = { "o", "x" } },
      { desc = "number",      keys = "im", mode = { "o", "x" } },
      { desc = "whitespace",  keys = "ao", mode = { "o", "x" } },
      { desc = "whitespace",  keys = "io", mode = { "o", "x" } },
      { desc = "paragraph",   keys = "ap", mode = { "o", "x" } },
      { desc = "paragraph",   keys = "ip", mode = { "o", "x" } },
      { desc = "quote",       keys = "aq", mode = { "o", "x" } },
      { desc = "quote",       keys = "iq", mode = { "o", "x" } },
      { desc = "sentence",    keys = "as", mode = { "o", "x" } },
      { desc = "sentence",    keys = "is", mode = { "o", "x" } },
      { desc = "tag",         keys = "at", mode = { "o", "x" } },
      { desc = "tag",         keys = "it", mode = { "o", "x" } },
      { desc = "subword",     keys = "au", mode = { "o", "x" } },
      { desc = "subword",     keys = "iu", mode = { "o", "x" } },
      { desc = "value",       keys = "av", mode = { "o", "x" } },
      { desc = "value",       keys = "iv", mode = { "o", "x" } },
      { desc = "word",        keys = "aw", mode = { "o", "x" } },
      { desc = "word",        keys = "iw", mode = { "o", "x" } },
      { desc = "WORD",        keys = "aW", mode = { "o", "x" } },
      { desc = "WORD",        keys = "iW", mode = { "o", "x" } },
      { desc = "hexadecimal", keys = "ax", mode = { "o", "x" } },
      { desc = "hexadecimal", keys = "ix", mode = { "o", "x" } },
      { desc = "user_prompt", keys = "a?", mode = { "o", "x" } },
      { desc = "user_prompt", keys = "i?", mode = { "o", "x" } },
    },
  })

  require('mini.base16').setup({
    --- `:Inspect` to reverse engineering a colorscheme
    --- `:hi <@treesitter>` to view colors of `:Inspect` output
    --- `:Pick hl_groups` to view generated colorscheme
    --> https://github.com/NvChad/base46/tree/v2.5/lua/base46/themes for popular colorscheme palettes
    --> https://github.com/echasnovski/mini.nvim/discussions/36 community palettes
    palette = {
      --- BAT_THEME=base16 --- tokyonight --- description
      base00 = "#000000", -- "#1a1b26", --- default bg
      base01 = "#111111", -- "#16161e", --- line number bg
      base02 = "#2c2c2c", -- "#2f3549", --- statusline bg, selection bg
      base03 = "#444b6a", -- "#444b6a", --- line number fg, comments
      base04 = "#787c99", -- "#787c99", --- statusline fg
      base05 = "#a9b1d6", -- "#a9b1d6", --- default fg, delimiters
      base06 = "#cbccd1", -- "#cbccd1", --- light fg (not often used)
      base07 = "#d5d6db", -- "#d5d6db", --- light bg (not often used)
      base08 = "#5555cc", -- "#7aa2f7", --- variables, tags, Diff delete
      base09 = "#999900", -- "#ff9e64", --- integers, booleans, constants, search fg
      base0A = "#ff0000", -- "#0db9d7", --- classes, search bg
      base0B = "#009900", -- "#73daca", --- strings, Diff insert
      base0C = "#3c3cff", -- "#2ac3de", --- builtins, regex
      base0D = "#5FB3A1", -- "#7aa2f7", --- functions
      base0E = "#8855ff", -- "#bb9af7", --- keywords, Diff changed
      base0F = "#a0a0a0", -- "#7aa2f7", --- punctuation, indentscope
    },
    use_cterm = true,     --- required if `nvim -c 'Pick files'`
  })

  --- neovim terminal colors
  vim.g.terminal_color_0 = "#3c3c3c"
  vim.g.terminal_color_1 = "#990000"
  vim.g.terminal_color_2 = "#009900"
  vim.g.terminal_color_3 = "#999900"
  vim.g.terminal_color_4 = "#5555cc"
  vim.g.terminal_color_5 = "#8855ff"
  vim.g.terminal_color_6 = "#5FB3A1"
  vim.g.terminal_color_7 = "#a0a0a0"
  vim.g.terminal_color_8 = "#6c6c6c"
  vim.g.terminal_color_9 = "#ff0000"
  vim.g.terminal_color_10 = "#00ff00"
  vim.g.terminal_color_11 = "#ffff00"
  vim.g.terminal_color_12 = "#1c1cff"
  vim.g.terminal_color_13 = "#8844bb"
  vim.g.terminal_color_14 = "#5DE4C7"
  vim.g.terminal_color_15 = "#ffffff"

  --- adding tokyonight transparency
  vim.api.nvim_set_hl(0, "Normal", { fg = "#787c99", bg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FoldColumn", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NeoCodeiumSuggestion", { fg = "#444b6a" })
  vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#787c99" })
  vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#a9b1d6" })
  vim.api.nvim_set_hl(0, "SnacksPickerDirectory", { fg = "#5555cc" })
  vim.api.nvim_set_hl(0, "Directory", { fg = "#5555cc" })
  -- vim.api.nvim_set_hl(0, "SnacksPickerFile", { fg = "#d5d6db" })
  vim.api.nvim_set_hl(0, "MiniIconsAzure", { fg = "#5555cc" })
  vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { underline = false, bg = "#1c1c2c" })
  vim.api.nvim_set_hl(0, "MiniCursorword", { bg = "#1c1c2c" })
  vim.api.nvim_set_hl(0, "LineNr", { fg = "#506477", bg = "NONE" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "Statusline", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "StatuslineNC", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "MiniDiffSignAdd", { fg = "#009900" })
  vim.api.nvim_set_hl(0, "MiniDiffSignChange", { fg = "#3C3CFf" })
  vim.api.nvim_set_hl(0, "MiniDiffSignDelete", { fg = "#990000" })
  vim.api.nvim_set_hl(0, "MiniClueDescGroup", { fg = "#8855ff" })
  vim.api.nvim_set_hl(0, "MiniClueNextKey", { fg = "#5fb3a1" })
  vim.api.nvim_set_hl(0, "MiniClueTitle", { fg = "#5fb3a1" })
  vim.api.nvim_set_hl(0, "MiniClueSeparator", { fg = "#3c3cff" })
  vim.api.nvim_set_hl(0, "diffAdded", { fg = "#009900" })
  vim.api.nvim_set_hl(0, "diffChanged", { fg = "#3C3CFf" })
  vim.api.nvim_set_hl(0, "diffRemoved", { fg = "#ff0000" })
  vim.api.nvim_set_hl(0, "DiffAdd", { fg = "#009900" })
  vim.api.nvim_set_hl(0, "DiffChange", { fg = "#3C3CFf" })
  vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#990000" })
  vim.api.nvim_set_hl(0, "DiffText", { bg = "#3C3CFf", fg = "#ffffff" })
  vim.api.nvim_set_hl(0, "SidekickDiffContext", { bg = "#00003c", blend = 50 }) --- blend for virtual line not suported, SidekickDiffContext = SidekickDiffAdd + SidekickDiffDelete rest of background
  vim.api.nvim_set_hl(0, "SidekickDiffAdd", { bg = "#003c00", blend = 50 })     --- blend for virtual line not suported, uses `Normal` background + foreground if treesitter not available
  vim.api.nvim_set_hl(0, "SidekickDiffDelete", { bg = "#3c0000", blend = 50 })  --- blend for virtual line not suported, doesn't diff well without treesitter
  vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#db4b4b" })
  vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#1abc9c" })
  vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#0db9d7" })
  vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#e0af68" })
  vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#db4b4b" })
  vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#1abc9c" })
  vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#0db9d7" })
  vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#e0af68" })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = true, sp = "#db4b4b" })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = true, sp = "#1abc9c" })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = true, sp = "#0db9d7" })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = true, sp = "#e0af68" })
  vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE" }) --- transparent mini.completion
  vim.api.nvim_set_hl(0, "PmenuSel", { fg = "NONE", bg = "#2c2c2c" })
  vim.api.nvim_set_hl(0, "PmenuMatch", { bold = true, fg = "#3C3CFf" })
  vim.api.nvim_set_hl(0, "Search", { fg = "#c0caf5", bg = "#3d59a1" })

  --- vim.fn.glob()   outputs nil if not found
  --- vim.fn.expand() outputs the same string if not founded
  local vscode_extensions = vim.fn.glob("~/.*/extensions", 0, 1)[1] or ''
  local snippet_path      = vim.fn.expand(vscode_extensions .. "/*/snippets", 0, 1)
  local snippet_dirname   = vim.tbl_map(vim.fs.dirname, snippet_path)
  vim.opt.rtp:append(snippet_dirname)

  require('mini.snippets').setup({
    snippets = { require('mini.snippets').gen_loader.from_runtime("*code-snippets") },
    mappings = {
      expand = '<a-.>',
      jump_next = '<a-n>',
      jump_prev = '<a-p>',
    }
  })

  require('mini.completion').setup()
  require('mini.cursorword').setup()
  require('mini.diff').setup({ view = { style = 'sign', signs = { add = '│', change = '│', delete = '│' } }, options = { wrap_goto = true } })
  require('mini.extra').setup()
  require('mini.cmdline').setup()
  require("mini.hipatterns").setup({ highlighters = { hex_color = require("mini.hipatterns").gen_highlighter.hex_color() } })
  require('mini.icons').setup()
  require('mini.icons').mock_nvim_web_devicons()
  require('mini.icons').tweak_lsp_kind( --[[ "replace" ]])
  require('mini.misc').setup_auto_root()
  require('mini.misc').setup_restore_cursor()
  require('mini.notify').setup({ window = { winblend = 0 } --[[ ,lsp_progress = { enable = false } ]] })
  require('mini.pick').setup()
  require('mini.pairs').setup()
  require('mini.snippets').start_lsp_server()
  require('mini.statusline').setup()
  require('mini.starter').setup()
  require('mini.tabline').setup()
  vim.notify = require('mini.notify').make_notify() --- `vim.print = MiniNotify.make_notify()` conflicts with `:=vim.opt.number`
  vim.opt.completeopt:append('fuzzy')               --- it should be after require("mini.completion").setup() otherwise auto trigger first suggestion
end

--- ╭────────────╮
--- │ Navigation │
--- ╰────────────╯

map({ "i" }, "jk", "<ESC>") --- disabled on visual mode since is slow
map({ "i" }, "kj", "<ESC>") --- disabled on visual mode since is slow
map({ "n" }, "J", "10gj")
map({ "n" }, "K", "10gk")
map({ "n" }, "H", "10h")
map({ "n" }, "L", "10l")
map({ "n" }, "Y", "yg_", { desc = "Yank forward" })          --- "Y" yank forward by default
map({ "x" }, "Y", "g_y", { desc = "Yank forward" })
map({ "x" }, "P", "g_P", { desc = "Paste forward" })         --- "P" doesn't change register
map({ "x" }, "p", '"_c<c-r>+<esc>', { desc = "Paste (dot repeat)(register unchanged)" })
map({ "n", "x" }, "U", "@:", { desc = "repeat `:command`" }) --> :normal A,jkj --> :normal A,j --->  escape char by pression ctrl+v then escape
map({ "n", "x", "o" }, "\\", "@q", { desc = "repeat q register/macro" })
map({ "n", "x", "o" }, "|", "@w", { desc = "repeat w register/macro" })
map({ "x" }, "<", "<gv", { desc = "continious indent" })
map({ "x" }, ">", ">gv", { desc = "continious indent" })
map({ "n" }, "<esc>", "<esc>:nohlsearch<cr>", { desc = "Clear Copilot-suggestion / search-highlight" })

if not vim.g.vscode then
  map({ "t" }, "<esc><esc>", "<C-\\><C-n>", { desc = "normal mode inside terminal" })
  map({ "t" }, "<S-esc>", "<C-\\><C-n>", { desc = "normal mode inside terminal" })
  map({ "n" }, "<C-s>", ":%s//g<Left><Left>", { desc = "Replace in Buffer" })
  map({ "x" }, "<C-s>", ":s//g<Left><Left>", { desc = "Replace in Visual_selected" })
  map({ "n" }, "<C-;>", "<C-6>", { desc = "go to last buffer" })
  map({ "n", "t" }, "<C-h>", "<C-\\><C-n><C-w>h", { desc = "left window or [w" })
  map({ "n", "t" }, "<C-j>", "<C-\\><C-n><C-w>j", { desc = "down window or ]w" })
  map({ "n", "t" }, "<C-k>", "<C-\\><C-n><C-w>k", { desc = "up window or [w" })
  map({ "n", "t" }, "<C-l>", "<C-\\><C-n><C-w>l", { desc = "right window or ]w" })
  map({ "n", "x", "t" }, "<C-S-l>", "<cmd>vertical resize -2<cr>", { desc = "vertical shrink" })
  map({ "n", "x", "t" }, "<C-S-h>", "<cmd>vertical resize +2<cr>", { desc = "vertical expand" })
  map({ "n", "x", "t" }, "<C-S-j>", "<cmd>resize -2<cr>", { desc = "horizontal shrink" })
  map({ "n", "x", "t" }, "<C-S-k>", "<cmd>resize +2<cr>", { desc = "horizontal shrink" })
  map({ "n" }, "<right>", "<cmd>bnext<CR>", { desc = "next buffer" })
  map({ "n" }, "<left>", "<cmd>bprevious<CR>", { desc = "prev buffer" })
  map({ "n" }, "<leader>x", "<cmd>bp | bd! #<CR>", { desc = " buffer close" }) --- `bd!` forces closing terminal buffer

  --> https://github.com/neovim/neovim/issues/9953
  map("c", "<Up>", [[pumvisible()    ? "<c-p>"      : "<Up>"]], { expr = true, desc = "navigate wildmenu" })
  map("c", "<Down>", [[pumvisible()  ? "<c-n>"      : "<Down>"]], { expr = true, desc = "navigate wildmenu" })
  map("c", "<c-p>", [[pumvisible()   ? "<c-e><c-p>" : "<c-p>"]], { expr = true, desc = "navigate history" })
  map("c", "<c-n>", [[pumvisible()   ? "<c-e><c-n>" : "<c-n>"]], { expr = true, desc = "navigate history" })
  map("i", "<Tab>", [[pumvisible()   ? "<c-n>"      : "<tab>"]], { expr = true, desc = "next completion when no lsp" })
  map("i", "<S-Tab>", [[pumvisible() ? "<c-p>"      : "<s-tab>"]], { expr = true, desc = "prev completion when no lsp" })
end

if not vim.g.vscode then
  map({ "n" }, "Q", "<cmd>lua vim.cmd.quit()<cr>")
  map({ "n" }, "R", "<cmd>lua vim.lsp.buf.format{ timeout_ms = 5000 } MiniTrailspace.trim() vim.cmd.write()<cr>")
else
  map({ "n" }, "Q", function() vscode.call('workbench.action.closeActiveEditor') end)
  map({ "n" }, "R", function()
    vscode.call('editor.action.format')
    vscode.call('workbench.action.files.save')
  end)
end

--- ╭────────────────╮
--- │ leader keymaps │
--- ╰────────────────╯

---@format disable
if not vim.g.vscode then
  ---------------------------------------------------------------------------------------------------------------------
  vim.lsp.config('*', { root_markers = { '.git' } })

  vim.diagnostic.config({
    update_in_insert = true,
    virtual_text = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.HINT] = "",
        [vim.diagnostic.severity.INFO] = "",
      },
    },
  })

  --> https://www.youtube.com/watch?v=ooTcnx066Do
  local sendSequence = function(sequence, continue_sequence)
    if not continue_sequence then
      vim.cmd.term()
    end
    vim.fn.chansend(vim.bo.channel, { sequence .. '\r' })
    vim.pack.add({{ src = 'https://github.com/neovim/nvim-lspconfig' }})
  end

  local fix_node_path = function()
    return vim.env.APPDATA
        and autocmd({ "TermLeave" }, {
          once = true,
          callback = function()
            vim.fn.filecopy(vim.env.HOME .. "/.pixi/envs/neovim-lsp/node.exe",
              vim.env.HOME .. "/.pixi/envs/neovim-lsp/bin/node.exe")
          end
        })
  end

  --> https://github.com/mason-org/mason-lspconfig.nvim/issues/371
  --> https://github.com/vuejs/language-tools/issues/5381
  vim.lsp.config['ts_ls']                 = {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = { 'vue', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    init_options = {
      plugins = {
        {
          name = '@vue/typescript-plugin',
          location = vim.env.HOME .. "/.pixi/envs/neovim-lsp/lib/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin",
          languages = { 'vue' },
        },
      },
    },
  }

  vim.lsp.enable({ 'bashls', 'biome', 'clangd', 'copilot', 'cssls', 'dockerls', 'emmet_language_server', 'gopls', 'html', 'intelephense', 'jdtls', 'jsonls', 'lua_ls', 'neocmake', 'omnisharp', 'oxfmt', 'prismals', 'ruff', 'rust_analyzer', 'sqlls', 'sqls', 'tailwindcss', 'taplo', 'terraformls', 'ts_ls', 'ty', 'yamlls' })

  map("n", "<leader>L", "", { desc = " LSP installer" }) --- relaunch nvim to autostart the new installed lsp
  map("n", "<leader>Lb", function() sendSequence('pixi g install --environment neovim-lsp bash-language-server=5.6.0') fix_node_path() end,                                                  { desc = " bash" })                      --- (no formatter press `=` to format selection)
  map("n", "<leader>Lc", function() sendSequence('pixi g install --environment neovim-lsp clang-tools=22.1.0 --expose clangd') end,                                                          { desc = " c/c++" })                     --- (+formatter)
  map("n", "<leader>LC", function() sendSequence('pixi g install --environment neovim-lsp omnisharp-roslyn=1.39.12') end,                                                                    { desc = " c#" })                        --- (+formatter)
  map("n", "<leader>Ld", function() sendSequence('pixi g install --environment neovim-lsp dockerfile-language-server-nodejs=0.15.0 ') fix_node_path() end,                                   { desc = " docker" })                    --- (+formatter)
  map("n", "<leader>Le", function() sendSequence('pixi g install --environment neovim-lsp emmet-language-server=2.8.0 ') fix_node_path() end,                                                { desc = " emmet (autoclose tag)" })     --- suggests <autoclose-this-tag> but not </close-some-open-tag> like vscode-html-language-server
  map("n", "<leader>Lf", function() sendSequence('pixi g install pnpm nodejs && pnpm install -g oxfmt') end,                                                                                 { desc = " oxfmt formatter/eslint" })
  map("n", "<leader>LF", function() sendSequence('pixi g install --environment neovim-lsp biome') end,                                                                                       { desc = " biome formatter/eslint" })    --- https://biomejs.dev/internals/language-support/
  map("n", "<leader>Lg", function() sendSequence('pixi g install --environment neovim-lsp gopls=0.20.0') end,                                                                                { desc = " go" })                        --- (+formatter)
  map("n", "<leader>Lh", function() sendSequence('pixi g install pnpm nodejs && pnpm install -g intelephense@1.16.5') end,                                                                   { desc = " php" })                       --- (+formatter)
  map("n", "<leader>Lj", function() sendSequence('pixi g install --environment neovim-lsp jdtls=1.57.0') end,                                                                                { desc = " java" })                      --- (+formatter)
  map("n", "<leader>Ll", function() sendSequence('pixi g install --environment neovim-lsp lua-language-server=3.17.1') end,                                                                  { desc = " lua for  " })               --- (+formatter)
  map("n", "<leader>LL", function() sendSequence('winget install luals.lua-language-server || scoop install lua-language-server') end,                                                       { desc = " lua for " })                 --- (+formatter)
  map("n", "<leader>LM", function() sendSequence('pixi g install --environment neovim-lsp neocmakelsp=0.10.1') end,                                                                          { desc = " cmake" })                     --- (+formatter +linter) https://github.com/regen100/cmake-language-server doesn't have formatter nor linter
  map("n", "<leader>Lp", function() sendSequence('pixi g install --environment neovim-lsp prisma-language-server=31.6.0') fix_node_path() end,                                               { desc = " prisma" })                    --- (+formatter)
  map("n", "<leader>LP", function() sendSequence('pixi g install --environment neovim-lsp ty=0.0.43 ruff=0.15.16') end,                                                                      { desc = " python" })                    --- (-formatter) means no formatter
  map("n", "<leader>Lr", function() sendSequence('pixi g install --environment neovim-lsp rust=1.94.0 --with rust-src') end,                                                                 { desc = " rust" })                      --- (+formatter)
  map("n", "<leader>LR", function() sendSequence('pixi g install --environment neovim-lsp terraform-ls=0.38.5') fix_node_path() end,                                                         { desc = " terraform" })                 --- (no formatter press `=` to format selection)
  map("n", "<leader>Ls", function() sendSequence('pixi g install --environment neovim-lsp sql-language-server=1.7.1 vscode-jsonrpc=8.2.1') fix_node_path() end,                              { desc = " sqlls(-formatter +linter)" }) --- (no formatter use sqls)
  map("n", "<leader>LS", function() sendSequence('pixi g install --environment neovim-lsp sqls=0.2.46') end,                                                                                 { desc = " sqls (+formatter -linter)" })
  map("n", "<leader>Lt", function() sendSequence('pixi g install --environment neovim-lsp tailwindcss-language-server=0.14.29') fix_node_path() end,                                         { desc = "󱏿 tailwindcss" })
  map("n", "<leader>LT", function() sendSequence('pixi g install --environment neovim-lsp taplo=0.10.0') end,                                                                                { desc = " toml" })                      --- (+formatter)
  map("n", "<leader>Lx", function() sendSequence('pixi g install --environment neovim-lsp vscode-langservers-extracted=4.10.0') fix_node_path() end,                                         { desc = "   css html json" })         --- (+formatter)
  map("n", "<leader>LX", function() sendSequence('pixi g install --environment neovim-lsp typescript=5.9.3 typescript-language-server=5.1.3 vue-language-server=3.2.8') fix_node_path() end, { desc = "   󰡄 " })                   --- (+formatter)
  map("n", "<leader>Ly", function() sendSequence('pixi g install --environment neovim-lsp yaml-language-server=1.21.0') fix_node_path() end,                                                 { desc = " yaml" })                      --- (+formatter)

  ------------------------------------------------------------------------------------------------------------------------

  map("n", "<leader>l", "", { desc = "󰗊 LSP" })
  map("n", "<leader>la", function() vim.lsp.buf.code_action() end, { desc = " code action" })
  map("n", "<leader>lc", function() vim.lsp.buf.incoming_calls() end, { desc = "Incoming Calls" })
  map("n", "<leader>lC", function() vim.lsp.buf.outcoming_calls() end, { desc = "Outcoming Calls" })
  map("n", "<leader>lb", "<cmd>Pick diagnostic<cr>", { desc = " diagnostic curr buffer" })
  map("n", "<leader>ld", "<cmd>Pick lsp scope='definition'<cr>", { desc = " pick definition" })
  map("n", "<leader>lD", "<cmd>Pick lsp scope='declaration'<cr>", { desc = " pick declaration" })
  map("n", "<leader>lF", function() vim.lsp.buf.format({ timeout_ms = 5000 }) end, { desc = "󰉢 format" })
  map("n", "<leader>lh", function() vim.lsp.buf.hover() end, { desc = "󰆽 hover" })
  map("n", "<leader>lH", function() vim.lsp.buf.signature_help() end, { desc = "󰽉 signature" })
  map("n", "<leader>lI", "<cmd>Pick lsp scope='implementation'<cr>", { desc = " pick implementation" })
  map("n", "<leader>lM", function() vim.cmd("checkhealth vim.lsp") end, { desc = " checkhealth lsp" })
  map("n", "<leader>ln", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = " diagnostic next" })
  map("n", "<leader>lo", function() vim.diagnostic.open_float() end, { desc = " diagnostic open" })
  map("n", "<leader>lp", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = " diagnostic previous" })
  map("n", "<leader>lq", "<cmd>Pick list scope='location'<cr>", { desc = " pick location list" })
  map("n", "<leader>lr", "<cmd>Pick lsp scope='references'<cr>", { desc = " pick references" })
  map("n", "<leader>lR", function() vim.lsp.buf.rename() end, { desc = "󰘎 rename" })
  map("n", "<leader>ls", "<cmd>Pick lsp scope='document_symbol'<cr>", { desc = " pick document symbols" })
  map("n", "<leader>lS", "<cmd>Pick lsp scope='workspace_symbol'<cr>", { desc = " pick workspace symbols" })
  map("n", "<leader>lt", "<cmd>Pick lsp scope='type_definition'<cr>", { desc = " pick typedefinition" })

  ------------------------------------------------------------------------------------------------------------------------

  map("n", "<leader>E", "", { desc = " extensions" })
  map(
    "n",
    "<leader>Ef",
    function()
      vim.pack.add({{ src = 'https://github.com/folke/flash.nvim', commit = "v2.1.0"}})
      vim.cmd.restart()
    end,
    { desc = " flash.nvim 󰉁" }
  )
  map(
    "n",
    "<leader>Ek",
    function()
      sendSequence("pixi g install copilot-language-server-release -c https://prefix.dev/retronvim")
      sendSequence("pixi g install nodejs pnpm && pnpm install -g @google/gemini-cli && exit", true)
      -- sendSequence([[nvim --server "$NVIM" --remote-send "<cmd>lsp enable copilot<cr>"]], true)
      vim.pack.add({{ src = 'https://github.com/folke/sidekick.nvim', version = 'v2.3.0' }})
      autocmd({ "TermLeave" }, { once = true, command = "lsp enable copilot" })
      require("sidekick").setup({})
    end,
    { desc = " sidekick 󰫣  " }
  )
  map(
    "n",
    "<leader>Es",
    function()
      vim.pack.add({{ src = "https://github.com/supermaven-inc/supermaven-nvim", commit = "07d20fce48a5629686aefb0a7cd4b25e33947d50"}})
      vim.cmd.restart("SupermavenUseFree")
    end,
    { desc = " supermaven  " }
  )
  map("n", "<leader>EF", function() vim.pack.del({"flash.nvim"}) vim.cmd.restart() end, { desc = " flash.nvim 󰉁 " })
  map("n", "<leader>EK", function() vim.pack.del({"sidekick.nvim"}) vim.cmd.restart() end, { desc = " sidekick 󰫣  " })
  map("n", "<leader>ES", function() vim.pack.del({"supermaven-nvim"}) vim.cmd.restart() end, { desc = " supermaven  " })
  map("n", "<leader>E?", function() vim.print(vim.pack.get()) end, { desc = "󱃔 installed extensions" })
  map("n", "<leader>E!", function() vim.cmd.checkhealth() end, { desc = " checkhealth extensions" })

  ------------------------------------------------------------------------------------------------------------------------

  map("n", "<leader>f", "", { desc = " find" })
  map("n", "<leader>fb", "<cmd>Pick buffers<cr>", { desc = "󱙈 buffers" })
  map("n", "<leader>fB", "<cmd>Pick buf_lines<cr>", { desc = "󰺮 ripgrep in buffers" })
  map("n", "<leader>fc", "<cmd>Pick colorscheme<cr>", { desc = " colorscheme" })
  map("n", "<leader>fk", "<cmd>Pick keymaps<cr>", { desc = "󰌌 keymaps" })
  map("n", "<leader>fn", function() require("mini.notify").show_history() end, { desc = "󰍩 notify history" })
  map(
    "n",
    "<leader>ff",
    function()
      vim.cmd.terminal([[ nvim --server $NVIM --remote "$(rg --files --sortr=path | fzf --no-sort --preview-window=nohidden)"]])
      vim.cmd.set("laststatus=0")
      autocmd("TermClose", { buffer = vim.fn.bufnr(), once = true, command = [[silent! bdelete! term*$NVIM* | set laststatus=3]] })
    end,
    { desc = " fzf files" }
  )
  map("n", "<leader>ft", "<cmd>Pick grep_live<cr>", { desc = " fzf text" })
  map("n", "<leader>fr", "<cmd>Pick oldfiles<cr>", { desc = "󱋡 recent files" })
  map("n", '<leader>f"', "<cmd>Pick registers<cr>", { desc = '󱛢 register (:help quote)' })
  map("n", "<leader>f'", "<cmd>Pick marks<cr>", { desc = " bookmarks" })
  map("n", "<leader>f;", "<cmd>Pick list scope='jump'<cr>", { desc = " jumps" })
  map("n", "<leader>f:", "q:", { desc = " :commands (U to repeat)" }) --- <cr> to execute command
  map("n", "<leader>f,", "<cmd>buffer #<cr>", { desc = "󰻡 recent buffer" })
  map("n", "<leader>g", "", { desc = "󰊢 git" })
  map(
    "n",
    "<leader>gg",
    function()
      vim.cmd.terminal("lazygit")
      autocmd("TermClose", { pattern = 'term*lazygit', command = [[silent! bdelete! term*lazygit]], once = true })
    end,
    { desc = " lazygit" }
  ) --- `:term lazygit` doesn't work on zsh.exe
  map("n", "<leader>gp", "<cmd>Pick git_hunks<cr>", { desc = " git-hunk preview" })
  map("n", "<leader>gr", "<cmd>lua MiniDiff.textobject() vim.cmd.normal('gH')<cr>", { desc = " git-hunk reset" })
  map("n", "<leader>gs", "<cmd>lua MiniDiff.textobject() vim.cmd.normal('gh')<cr>", { desc = " git-hunk stage" })
  map("n", "<leader>u", "", { desc = "󰨙 UI" })
  map("n", "<leader>ub", function() vim.o.showtabline = vim.o.showtabline == 0  and 2 or 0 end, { desc = "󰔡 bufferline" })
  map("n", "<leader>uc", function() vim.o.number = not vim.o.number end, { desc = "󰔡 statuscolumn" })
  map("n", "<leader>ud", function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, { desc = "󰔡 diagnostic" })
  map("n", "<leader>uf", function() vim.o.foldmethod = vim.o.foldmethod == 'expr'  and 'indent' or 'expr' end, { desc = "󰔢 fold by indent or lsp" })
  map("n", "<leader>ul", "<cmd>set cursorline!<cr>", { desc = "󰔢 cursorline" })
  map("n", "<leader>up", "<cmd>popup PopUp<cr>", { desc = "󰔢 mouse-popup" })
  map("n", "<leader>us", function() vim.o.laststatus = vim.o.laststatus == 0  and 3 or 0 end, { desc = "󰔡 statusline" })
  map("n", "<leader>t", "<cmd>term<cr>", { desc = " term tab" })
  map("n", "<leader>v", "<cmd>vsplit | terminal<cr>", { desc = " term horizontal" })
  map("n", "<leader>V", "<cmd>split  | terminal<cr>", { desc = " term vertical" })
  map("n", "<leader>w", "", { desc = " window" })
  map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = " vertical window" })
  map("n", "<leader>wV", "<cmd>split<cr>", { desc = " horizontal window" })
  map(
    "n",
    "<leader>e",
    function()
      --- toggle explorer
      if M.netrw_buf then
        vim.cmd.bdelete(M.netrw_buf)
        M.netrw_buf = nil
        return
      end

      local path = vim.split(vim.fn.expand('%'),"/")
      vim.cmd.Explore(vim.fn.getcwd()) --- Explore() restores tree at getcwd() which is changed to .git path by mini.misc
      vim.cmd.buffer("#")
      vim.cmd.Vexplore({bang = true})

      --- https://superuser.com/questions/1531456/how-to-reveal-a-file-in-vim-netrw-treeview
      --- focus current file (needs to address more edge cases)
      for _, dir in ipairs(path) do
        vim.fn.search(dir)
      end
      vim.cmd.normal("zb") -- redraw at bottom
    end,
    { desc = "󰙅 explorer" }
  )
  map(
    "n",
    "<leader>o",
    function()
      local curr_file = vim.fs.normalize(vim.fn.expand('%:p'))
      vim.cmd.terminal(
        'echo ' .. curr_file .. '              > $HOME/.yazi;' ..
        'yazi ' .. curr_file .. ' --chooser-file $HOME/.yazi;' ..
        'nvim --server $NVIM --remote     "$(cat $HOME/.yazi)";'
        -- .. 'nvim --server $NVIM --remote-send "<cmd>bdelete! \\#<cr>"'
      )
      vim.cmd.set("laststatus=0")
      autocmd("TermClose", { buffer = vim.fn.bufnr(), command = [[silent! bdelete! ]] .. vim.fn.bufnr() .. [[ | set laststatus=3]], once = true })
    end,
    { desc = "󰙅 yazi" }
  )
else
  map(
    "n",
    "<leader>o",
    function() return vscode.action("workbench.files.action.focusFilesExplorer") end,
    { desc = "󰙅 explorer/previewer" }
  )
end

------------------------------------------------------------------------------------------------------------------------
map({ "n", "x" }, "<leader><leader>", "", { desc = "󰅌 second clipboard" })
map("n", "<leader><leader>p", '"*p', { desc = "󰨸 paste after" })
map("n", "<leader><leader>P", '"*P', { desc = "󰨸 paste before" })
map("x", "<leader><leader>p", '"*p', { desc = "󰨸 paste" }) --- "Paste after (second_clip)"
map("x", "<leader><leader>P", 'g_"*P', { desc = "󰨸 paste forward" }) --- only works in visual mode
map("n", "<leader><leader>y", '"*y', { desc = "󰅍 yank" })
map("n", "<leader><leader>Y", '"*yg_', { desc = "󰅍 yank forward" })
map("x", "<leader><leader>y", '"*y', { desc = "󰅍 yank" })
map("x", "<leader><leader>Y", 'g_"*y', { desc = "󰅍 yank forward" })

--- ╭───────────────────────────────────╮
--- │ Operator / Motions / text objects │
--- ╰───────────────────────────────────╯

map({ "o" }, "g\\", [[setreg('q',             'v' . getcharstr() . getcharstr() . '<esc>`>l') ? "" : ":exec 'normal ' . getreg('q')<cr>" ]], { expr = true, remap = true, desc = "textobj end (dot to repeat)" })   --- paragraph textobj needs `>l
map({ "o" }, "g|",  [[setreg('q',             'v' . getcharstr() . getcharstr() . 'o<esc>'  ) ? "" : ":exec 'normal ' . getreg('q')<cr>" ]], { expr = true, remap = true, desc = "textobj start (dot to repeat)" }) --- remap=true to detect mini.ai
map({ "n" }, "g\\", [[setreg('q',             'v' . getcharstr() . getcharstr() . '<esc>`>' ) ? "" : "@q"                                ]], { expr = true, remap = true, desc = "textobj end (\\ repeats)" })      --- remap=true to detect mini.ai
map({ "n" }, "g|",  [[setreg('w',             'v' . getcharstr() . getcharstr() . '<esc>`<' ) ? "" : "@w"                                ]], { expr = true, remap = true, desc = "textobj start (| repeats)" })     --- remap=true to detect mini.ai
map({ "x" }, "g\\", [[setreg('q','<esc>mT`<mS`Tv' . getcharstr() . getcharstr() . 'o`So'    ) ? "" : "@q"                                ]], { expr = true, remap = true, desc = "textobj end (\\ repeats)" })      --- remap=true to detect mini.ai
map({ "x" }, "g|",  [[setreg('w','<esc>mT`>mS`Tv' . getcharstr() . getcharstr() . '`So'     ) ? "" : "@w"                                ]], { expr = true, remap = true, desc = "textobj start (| repeats)" })     --- remap=true to detect mini.ai
map( "x", "go", [[<cmd>let _=&commentstring | set commentstring={/*\ %s\ */} | normal gc<cr><cmd>let &commentstring=_<cr>]], { desc = "jsx comment" })
map({ "n", "x" }, "gb", '"_d', { desc = "Blackhole Motion/Selected (dot to repeat)" })
map({ "n", "x" }, "gB", '"_D', { desc = "Blackhole Linewise (dot to repeat)" })
map({ "n", "o", "x" }, "g.", "`.", { desc = "go to last change" })
map({ "n" }, "gy", '"1p', { desc = "Redo register (dot to Paste forward the rest of register)" })
map({ "n" }, "gY", '"1P', { desc = "Redo register (dot to Paste backward the rest of register)" })
map({ "n" }, "g<Up>", "<c-a>", { desc = "numbers ascending" })
map({ "n" }, "g<Down>", "<c-x>", { desc = "numbers descending" })
map({ "x" }, "g<Up>", "g<c-a>", { desc = "numbers ascending" })
map({ "x" }, "g<Down>", "g<c-x>", { desc = "numbers descending" })
map({ "n", "x" }, "g+", "<C-a>", { desc = "Increment number (dot to repeat)" })
map({ "n", "x" }, "g-", "<C-x>", { desc = "Decrement number (dot to repeat)" })
map({ "n" }, "vgh", "<cmd>lua require('mini.diff').textobject()<cr>", { desc = "select diff/hunk" })
map({ "n" }, "vgc", "<cmd>lua require('mini.comment').textobject()<cr>", { desc = "select BlockComment" })
map({ "n", "o", "x" }, "gC", function() require('mini.comment').textobject() end, { desc = "select BlockComment" })
map({ "n", "o", "x" }, "gD", function() require('mini.diff').textobject() end, { desc = "select diff/hunk" })
map({ "o", "x" }, "ii", function() require("mini.ai").select_textobject("i", "i") end, { desc = "indent_noblanks" })
map({ "o", "x" }, "ai", "<cmd>normal Viioko<cr>", { desc = "indent_noblanks" })
