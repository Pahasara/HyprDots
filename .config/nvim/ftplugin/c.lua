local opt = vim.opt_local

opt.cindent = true
opt.smartindent = false
local compiler = vim.fn.executable 'clang' == 1 and 'clang' or 'cc'

opt.makeprg = compiler .. ' -fsyntax-only -Wall -Wextra -Wpedantic -std=c23 %:p'
opt.errorformat = table.concat({
  '%E%f:%l:%c: error: %m',
  '%W%f:%l:%c: warning: %m',
  '%E%f:%l:%c: fatal error: %m',
  '%E%f:%l:%c: %m',
  '%-G%.%#',
}, ',')

-- vim: ts=2 sts=2 sw=2 et
