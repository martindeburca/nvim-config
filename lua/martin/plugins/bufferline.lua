return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  opts = {
    options = {
      mode = "tabs",
      separator_style = "slant",
      -- Show a custom tab name (set via :TabRename / <leader>tr) when one
      -- exists, otherwise fall back to bufferline's default label (the active
      -- buffer's filename). Neovim tabpages have no native name, so we store
      -- it as a tabpage-scoped variable and look it up here per tab.
      name_formatter = function(buf)
        if buf.tabnr then
          local handle = vim.api.nvim_list_tabpages()[buf.tabnr]
          if handle then
            local ok, name = pcall(vim.api.nvim_tabpage_get_var, handle, "tabname")
            if ok and name and name ~= "" then
              return name
            end
          end
        end
        return nil -- nil = keep bufferline's default label
      end,
    },
  },
  config = function(_, opts)
    require("bufferline").setup(opts)

    -- Set/clear the current tabpage's name and refresh the tab bar.
    local function set_tab_name(name)
      if name == nil or name == "" then
        pcall(vim.api.nvim_tabpage_del_var, 0, "tabname")
      else
        vim.api.nvim_tabpage_set_var(0, "tabname", name)
      end
      vim.cmd("redrawtabline")
    end

    -- :TabRename <name>   (no argument clears the custom name)
    vim.api.nvim_create_user_command("TabRename", function(a)
      set_tab_name(a.args)
    end, { nargs = "?", desc = "Rename the current tab (no arg = clear)" })

    -- <leader>tr : prompt for a tab name (uses dressing.nvim's input UI).
    vim.keymap.set("n", "<leader>tr", function()
      vim.ui.input({ prompt = "Tab name: " }, function(input)
        if input ~= nil then
          set_tab_name(input)
        end
      end)
    end, { desc = "Rename current tab" })
  end,
}
