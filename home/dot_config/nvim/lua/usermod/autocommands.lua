-- Setting spaces to 2 for yaml,yml,toml files
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "yaml", "yml", "toml" },
	callback = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.expandtab = true
	end,
})

-- Use tabs in go files
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "go" },
	callback = function ()
		vim.opt_local.expandtab = false
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 4
		vim.opt_local.tabstop = 4
	end
})
