return {
  "lervag/vimtex",
  ft = { "tex", "plaintex", "latex" },
  config = function()
    -- On macOS, use the general viewer and point it to zathura explicitly.
    vim.g.vimtex_view_method = "general"
    vim.g.vimtex_view_general_viewer = "zathura"
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_compiler_latexmk = {
      build_dir = "",
      callback = 1,
      continuous = 1,
      executable = "latexmk",
      options = {
        "-pdf",
        "-synctex=1",
        "-interaction=nonstopmode",
        "-file-line-error",
      },
    }
  end,
}
