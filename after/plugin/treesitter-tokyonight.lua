-- ~/.config/nvim/after/plugin/treesitter-tokyonight.lua
--
-- Tokyonight-focused Tree-sitter highlight overrides.
-- Goal: differentiate variables, modules/imports, properties, and types in Python (and generally),
-- while remaining robust to colorscheme reapplication and late highlight overrides.

local function apply_treesitter_overrides()
	-- Variables
	vim.api.nvim_set_hl(0, "@variable", { link = "Identifier" })
	vim.api.nvim_set_hl(0, "@variable.parameter", { link = "Special" })
	vim.api.nvim_set_hl(0, "@variable.member", { link = "Structure" })

	-- Properties (often used for dotted names / attributes)
	-- If you prefer properties to look like members rather than imports, change Include -> Structure.
	vim.api.nvim_set_hl(0, "@property", { link = "Include" })

	-- Modules / namespaces (imports)
	-- If Include is too subtle in your Tokyonight variant, change Include -> Keyword.
	vim.api.nvim_set_hl(0, "@module", { fg = "#3D8F5A" })
	vim.api.nvim_set_hl(0, "@module.builtin", { fg = "#3D8F5A" })
	vim.api.nvim_set_hl(0, "@namespace", { fg = "#3D8F5A" })

	-- Types (imported classes, typing constructs, annotations)
	vim.api.nvim_set_hl(0, "@type", { link = "Type" })
	vim.api.nvim_set_hl(0, "@type.builtin", { link = "Type" })
	vim.api.nvim_set_hl(0, "@constructor", { link = "Type" })

	-- Function names (optional; keep subtle)
	vim.api.nvim_set_hl(0, "@function", { link = "Function" })
	vim.api.nvim_set_hl(0, "@function.call", { link = "Function" })
end

-- Apply once immediately (covers first load)
apply_treesitter_overrides()

-- Re-apply after any colorscheme set, but scheduled to run after theme/plugin highlight setup
local group = vim.api.nvim_create_augroup("MartinTreesitterTokyonightHL", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
	group = group,
	callback = function()
		vim.schedule(apply_treesitter_overrides)
	end,
})

-- Some setups (or plugins) adjust highlights after startup; re-apply once when UI is ready
vim.api.nvim_create_autocmd("UIEnter", {
	group = group,
	once = true,
	callback = function()
		vim.schedule(apply_treesitter_overrides)
	end,
})
