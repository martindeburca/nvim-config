local function fix_treesitter_vars()
	vim.api.nvim_set_hl(0, "@variable", { link = "Identifier" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = fix_treesitter_vars,
})

fix_treesitter_vars()
