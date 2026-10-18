local opt = vim.opt -- for conciseness

-- tabs & indentation
opt.tabstop = 2 -- number of visual spaces per TAB
opt.shiftwidth = 2 -- insert 2 spaces on a tab
opt.softtabstop = 2

-- Treesitter-based folding
vim.wo[0][0].foldmethod = 'expr'
vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
