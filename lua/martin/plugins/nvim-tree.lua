return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local nvimtree = require("nvim-tree")

    -- recommended settings from nvim-tree documentation
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- Files of the types in martin.core.external (video, images, PDFs, Office, ...) go
    -- straight to their default app, without opening a buffer, so the tree stays open
    -- and keeps focus. Everything else opens as usual.
    local function on_attach(bufnr)
      local api = require("nvim-tree.api")
      local external = require("martin.core.external")
      api.config.mappings.default_on_attach(bufnr)

      local function open_or_external()
        local node = api.tree.get_node_under_cursor()
        local path = node and node.type == "file" and node.absolute_path
        if path and external.is_external(path) then
          local ok, err = external.open(path)
          if not ok then
            vim.notify("Could not open " .. path .. " externally: " .. tostring(err), vim.log.levels.ERROR)
          end
        else
          api.node.open.edit()
        end
      end

      local function map(keys, fn, desc)
        for _, key in ipairs(keys) do
          vim.keymap.set("n", key, fn,
            { buffer = bufnr, noremap = true, silent = true, nowait = true, desc = "nvim-tree: " .. desc })
        end
      end

      map({ "<CR>", "o", "<2-LeftMouse>" }, open_or_external, "Open")

      -- l / Right: open a folder (or step into it when already open), open a file.
      -- h / Left: close the folder under the cursor, or else its parent folder.
      -- (Enter and Backspace keep working as before.)
      map({ "l", "<Right>" }, function()
        local node = api.tree.get_node_under_cursor()
        if node and node.type == "directory" and node.open then
          vim.cmd("normal! j")
        else
          open_or_external()
        end
      end, "Open / into folder")
      map({ "h", "<Left>" }, function()
        local node = api.tree.get_node_under_cursor()
        if node and node.type == "directory" and node.open then
          api.node.open.edit() -- collapses an open folder
        else
          api.node.navigate.parent_close()
        end
      end, "Close folder / parent")
    end

    nvimtree.setup({
      on_attach = on_attach,
      view = {
        width = 50,
        relativenumber = true,
      },
      -- change folder arrow icons
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "", -- arrow when folder is closed
              arrow_open = "", -- arrow when folder is open
            },
          },
        },
      },
      -- disable window_picker for
      -- explorer to work well with
      -- window splits
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        },
      },
      filters = {
        custom = { ".DS_Store" },
      },
      git = {
        ignore = false,
      },
      -- Don't watch high-churn directories. Temp/caches/deps generate floods of
      -- filesystem events that trip nvim-tree's max_events guard (the warning
      -- about C:\...\AppData\Local\Temp) and aren't useful in the tree anyway.
      -- Patterns are Lua patterns matched against the directory path; [/\\]
      -- covers both Windows and Unix separators, so this is cross-platform.
      filesystem_watchers = {
        ignore_dirs = {
          "node_modules",
          "%.git",
          "%.venv",
          "AppData[/\\]Local[/\\]Temp", -- Windows temp
          "/tmp",                        -- Unix temp
        },
      },
    })

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
    keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
  end
}
