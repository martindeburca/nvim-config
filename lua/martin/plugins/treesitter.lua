-- nvim-treesitter, MAIN branch (the modern Neovim-0.11+/0.12 API).
-- The old `require("nvim-treesitter.configs").setup{ ensure_installed, highlight,
-- indent, autotag, incremental_selection }` interface no longer exists on main:
--   * highlighting is enabled per-buffer via vim.treesitter.start() (FileType autocmd below),
--   * parsers are installed with require("nvim-treesitter").install(...),
--   * indentation is opt-in via indentexpr,
--   * autotag is configured through the separate nvim-ts-autotag plugin,
--   * incremental_selection is no longer provided by the plugin (dropped).
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    local ts = require("nvim-treesitter")
    ts.setup({}) -- default install_dir = stdpath('data')/site

    -- Parsers to keep installed (into stdpath('data')/site/parser).
    local ensure_installed = {
      "c", "cpp", "python", "json", "javascript", "typescript", "tsx", "yaml",
      "html", "css", "prisma", "markdown", "markdown_inline", "svelte",
      "graphql", "bash", "lua", "vim", "dockerfile", "gitignore", "query", "vimdoc",
    }
    -- exposed so scripts/bootstrap-mac.sh can install them all and wait for the compile
    vim.g.martin_ts_parsers = ensure_installed
    -- A restricted machine has no compiler for parsers, so don't try to install them.
    -- Any parser already present still highlights; the rest fall back to Vim syntax.
    local restricted = require("martin.core.restricted").enabled()
    local installed = ts.get_installed()
    local missing = vim.tbl_filter(function(lang)
      return not vim.tbl_contains(installed, lang)
    end, ensure_installed)
    if #missing > 0 and not restricted then
      ts.install(missing) -- async; compiles in the background
    end

    -- Enable Treesitter highlighting (+ experimental indentation) for any buffer
    -- whose filetype has a parser. vim.treesitter.start() errors when no parser
    -- exists, so guard it with pcall.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("MartinTreesitter", { clear = true }),
      callback = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match)
        if lang and pcall(vim.treesitter.start, ev.buf, lang) then
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    -- Auto-close / auto-rename HTML/JSX tags (was `autotag = { enable = true }`).
    require("nvim-ts-autotag").setup()
  end,
}
