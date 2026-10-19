-- obsidian.nvim (community fork): edit the Obsidian vault at ~/git/Learning from Neovim.
-- In notes: <CR> follows a link / lists a tag / toggles a checkbox; ]o and [o jump between links;
-- [[ completes note links, # completes tags. LSP keys also work: gd follows a link,
-- gR shows backlinks, <leader>rn renames a note and updates every link to it.
return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- latest release, not the main branch
  -- only on machines that have the vault (skips the work PC, where ~/git/Learning does not exist)
  cond = function()
    return vim.fn.isdirectory(vim.fn.expand("~/git/Learning")) == 1
  end,
  ft = "markdown",
  cmd = "Obsidian",
  dependencies = { "nvim-telescope/telescope.nvim" },
  init = function()
    -- obsidian.nvim's UI (tidy links, drawn checkboxes) needs conceal; Markdown files only
    -- set on BufReadPre, before the plugin loads on FileType, so its startup check sees it
    vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile", "FileType" }, {
      pattern = { "*.md", "markdown" },
      callback = function()
        vim.opt_local.conceallevel = 2
      end,
    })
  end,
  keys = {
    { "<leader>oq", "<cmd>Obsidian quick_switch<CR>", desc = "Obsidian: switch to a note" },
    { "<leader>os", "<cmd>Obsidian search<CR>", desc = "Obsidian: search notes (text)" },
    { "<leader>on", "<cmd>Obsidian new<CR>", desc = "Obsidian: new note" },
    { "<leader>ob", "<cmd>Obsidian backlinks<CR>", desc = "Obsidian: backlinks to this note" },
    { "<leader>ol", "<cmd>Obsidian links<CR>", desc = "Obsidian: links in this note" },
    { "<leader>oc", "<cmd>Obsidian toc<CR>", desc = "Obsidian: table of contents" },
    { "<leader>ot", "<cmd>Obsidian tags<CR>", desc = "Obsidian: find tags" },
    { "<leader>od", "<cmd>Obsidian today<CR>", desc = "Obsidian: today's daily note" },
    { "<leader>oo", "<cmd>Obsidian open<CR>", desc = "Obsidian: open this note in the Obsidian app" },
  },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false, -- use `:Obsidian <subcommand>` only
    workspaces = {
      { name = "learning", path = "~/git/Learning" },
    },
    picker = { name = "telescope.nvim" },
    daily_notes = { folder = "Daily" }, -- ~/git/Learning/Daily/YYYY-MM-DD.md
  },
}
