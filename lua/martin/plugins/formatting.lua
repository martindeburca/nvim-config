return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        liquid = { "prettier" },
        lua = { "stylua" },
        python = { "ruff_organize_imports", "ruff_format" }, -- matches `ruff format` convention
      },
      format_on_save = function(bufnr)
        -- never auto-reformat C/C++ on save (clangd would apply LLVM style); use <leader>mp
        local ft = vim.bo[bufnr].filetype
        if ft == "c" or ft == "cpp" then
          return nil
        end
        return { lsp_fallback = true, async = false, timeout_ms = 1000 }
      end,
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
