local opt = vim.opt -- for conciseness

-- tabs & indentation
opt.tabstop = 2 -- number of visual spaces per TAB
opt.shiftwidth = 2 -- insert 2 spaces on a tab
opt.softtabstop = 2

-- Try to start treesitter for this custom filetype (if a parser exists)
pcall(function()
	if vim.treesitter and vim.treesitter.start then
		vim.treesitter.start()
	end
end)

-- Enable treesitter-based folding where available
pcall(function()
	vim.wo.foldmethod = 'expr'
	vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
end)
