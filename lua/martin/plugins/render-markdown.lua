-- In-buffer markdown rendering: headings, bullets, code blocks, tables,
-- checkboxes, callouts rendered inline as you edit. Pure Lua (no build step);
-- uses the treesitter markdown parsers. Toggle raw/rendered with :RenderMarkdown toggle.
return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- markdown / markdown_inline parsers
    "nvim-tree/nvim-web-devicons", -- icon provider
  },
  ft = { "markdown" },
  opts = {},
}
