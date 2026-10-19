return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			-- Windows has no `make`; build the native sorter with CMake (uses MSVC).
			-- On Unix `make` is present, so keep the simpler command there.
			build = vim.fn.executable("make") == 1 and "make"
				or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
		},
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")

		-- File types opened outside Neovim (PDFs, video, images, Office files, notebooks):
		-- the list is in martin.core.external, shared with the BufReadCmd autocmd.
		local external = require("martin.core.external")

		-- <CR> handler: for those types, close the picker and open externally
		-- WITHOUT editing (so no buffer is created and you stay on your current
		-- buffer); otherwise behave exactly like the normal select action.
		local function select_or_open_external(prompt_bufnr)
			local entry = action_state.get_selected_entry()
			local path = entry and (entry.path or entry.filename or entry.value or entry[1])
			if external.is_external(path) then
				actions.close(prompt_bufnr)
				local ok, err = external.open(path)
				if not ok then
					vim.notify("Could not open " .. path .. " externally: " .. tostring(err), vim.log.levels.ERROR)
				end
			else
				actions.select_default(prompt_bufnr)
			end
		end

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<CR>"] = select_or_open_external, -- media, PDFs, Office -> OS app; notebooks -> JupyterLab
					},
					n = {
						["<CR>"] = select_or_open_external, -- media, PDFs, Office -> OS app; notebooks -> JupyterLab
					},
				},
			},
		})

		telescope.load_extension("fzf")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
		keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Show open buffers" })
	end,
}
