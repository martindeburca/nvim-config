return {
	"kdheepak/lazygit.nvim",
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	-- optional for floating window border decoration
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	-- setting the keybinding for LazyGit with 'keys' is recommended in
	-- order to load the plugin when the command is run for the first time
	keys = {
		{
			"<leader>lg",
			function()
				local width = math.floor(vim.o.columns * 0.9)
				local height = math.floor(vim.o.lines * 0.9)
				local row = math.floor((vim.o.lines - height) / 2)
				local col = math.floor((vim.o.columns - width) / 2)

				local buf = vim.api.nvim_create_buf(false, true)
				local win = vim.api.nvim_open_win(buf, true, {
					relative = "editor",
					style = "minimal",
					border = "rounded",
					width = width,
					height = height,
					row = row,
					col = col,
				})

				vim.bo[buf].bufhidden = "wipe"

				vim.keymap.set("n", "q", function()
					if vim.api.nvim_win_is_valid(win) then
						vim.api.nvim_win_close(win, true)
					end
				end, { buffer = buf, silent = true, nowait = true })

				vim.api.nvim_buf_call(buf, function()
					vim.fn.termopen({ "lazygit" }, {
						on_exit = function()
							if vim.api.nvim_win_is_valid(win) then
								vim.api.nvim_win_close(win, true)
							end
						end,
					})
					vim.cmd("startinsert")
				end)
			end,
			desc = "Open lazy git",
		},
	},
}
