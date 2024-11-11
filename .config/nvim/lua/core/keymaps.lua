-- NOTE: [[ Basic Keymaps ]]
--  See `:help keymap.set()`

--  WARNING: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

local keymap = vim.keymap -- for conciseness

-- Set custom Escape
keymap.set('i', "''", '<ESC>', { desc = 'Exit insert mode with kj' })

-- Jump-motions
keymap.set('n', '<leader>bb', '<C-o>', { desc = 'Goto older cursor position' })
keymap.set('n', '<leader>nn', '<C-i>', { desc = 'Goto newer cursor position' })

-- Increment/Decrement numbers
keymap.set('n', '<leader>+', '<C-a>', { desc = 'Increment number' })
keymap.set('n', '<leader>-', '<C-x>', { desc = 'Decrement number' })

-- Terminal
keymap.set('n', '<leader>tt', '<C-w>s<CR><cmd>terminal<CR>', { desc = 'Open terminal horizontally' })

-- Highlight clear
keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
keymap.set('n', '<leader>nh', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

-- Window managent
keymap.set('n', '<leader>sv', '<C-w>v', { desc = 'Split window vertically' })
keymap.set('n', '<leader>sh', '<C-w>s', { desc = 'Split window horizontally' })
keymap.set('n', '<leader>sc', '<C-w>=', { desc = 'Make splits equal size' })
keymap.set('n', '<leader>xx', '<cmd>close<CR>', { desc = 'Close current split' })

-- Tab management
keymap.set('n', '<C-n>', '<cmd>tabnew<CR>', { desc = 'Open new tab' })
keymap.set('n', '<leader>tx', '<cmd>tabclose<CR>', { desc = 'Close current tab' })
keymap.set('n', '<Tab>', '<cmd>tabn<CR>', { desc = 'Go to next tab' })
keymap.set('n', '<S-Tab>', '<cmd>tabp<CR>', { desc = 'Go to previous tab' })
keymap.set('n', '<leader>tn', '<cmd>tabnew %<CR>', { desc = 'Open current buffer in new tab' })

-- Diagnostic keymaps
keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Show Line Diagonstics' })
keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Goto previous Diagnostic' })
keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Goto next Diagnostic' })
keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic Quickfix list' })
keymap.set('n', '<leader>D', '<cmd>Telescope diagnostics bufnr=0<CR>', { desc = 'Show Buffer Diagnostics' }) -- show  diagnostics for file

-- Information keymaps
keymap.set('n', '<leader>il', ':LspInfo<CR>', { desc = 'Show LSP Info' })
keymap.set('n', '<leader>it', ':TSInstallInfo<CR>', { desc = 'Show Treesitter' })
keymap.set('n', '<leader>ii', ':Mason<CR>', { desc = 'Show Mason' })
keymap.set('n', '<leader>io', ':Lazy<CR>', { desc = 'Show Lazy' })

-- Keybinds to make split navigation easier.
keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- vim: ts=2 sts=2 sw=2 et
