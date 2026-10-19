return {
  "mason-org/mason.nvim",
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- On a restricted machine the downloaded servers/formatters would be blocked by
    -- application control, so don't ask Mason to install anything. Whatever is already
    -- present (and the already-installed Mason UI) still works.
    local restricted = require("martin.core.restricted").enabled()

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install (none on a restricted machine)
      ensure_installed = restricted and {} or {
        "ts_ls",
        "html",
        "cssls",
        "svelte",
        "lua_ls",
        "pyright",
      },
      -- avoid auto-enabling before we configure vim.lsp.config in lspconfig.lua
      automatic_enable = false,
    })

    mason_tool_installer.setup({
      ensure_installed = restricted and {} or {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "eslint_d", -- js linter
      },
    })
  end,
}
