return {
  {
    "Mofiqul/vscode.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("vscode").setup({
        style = "dark",
        italic_comments = true,
      })
      -- load the colorscheme here
      vim.cmd([[colorscheme vscode]])
    end,
  },
}
