local opt = vim.opt_local
local compiler = vim.fn.executable 'clang++' == 1 and 'clang++' or 'c++'

opt.makeprg = compiler .. ' -fsyntax-only -Wall -Wextra -Wpedantic -std=c++23 %:p'
opt.errorformat = table.concat({
  '%E%f:%l:%c: error: %m',
  '%W%f:%l:%c: warning: %m',
  '%E%f:%l:%c: fatal error: %m',
  '%E%f:%l:%c: %m',
  '%-G%.%#',
}, ',')

-- vim: ts=2 sts=2 sw=2 et

