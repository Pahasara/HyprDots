-- NOTE: [[ Setting options ]]
-- See `:help opt`

vim.cmd 'let g:netrw_liststyle = 3'
local opt = vim.opt -- for conciseness

opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 4 -- number of visual spaces per TAB
opt.shiftwidth = 4 -- insert 4 spaces on a tab
opt.expandtab = true -- tabs are spaces, mainly because of python
opt.autoindent = true

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if u include mixed case in ur search, assumes you want casesensitive
opt.hlsearch = true -- enable highlight search

-- termguicolors
opt.termguicolors = true
opt.background = 'dark'

-- backspace
opt.backspace = 'indent,eol,start' -- allow backspace on indent, EOF or insert mode start position

-- clipboard
opt.clipboard:append 'unnamedplus' -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- Enable mouse mode, can be useful for resizing splits for example!
opt.mouse = 'a'

-- Enable show mode [NORMAL, INSERT, V-BLOCK]
opt.showmode = false

-- Enable break indent
opt.breakindent = true

-- Save undo history
opt.undofile = true

-- Keep signcolumn on by default
opt.signcolumn = 'yes'

-- Decrease update time
opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
opt.timeoutlen = 300

-- Configure how new splits should be opened
opt.splitright = true
opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
opt.inccommand = 'split'

-- Show which line your cursor is on
opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 10

-- For blank lines
vim.wo.fillchars = 'eob: '

-- Configuration of diagnostic messages
vim.diagnostic.config {
  virtual_text = false,
  underline = true,
}

-- vim: ts=2 sts=2 sw=2 et
