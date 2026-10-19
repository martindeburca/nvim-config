return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- for conciseness

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        keymap.set("n", "gl", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
      end,
    })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    local servers = {
      "ts_ls",
      "html",
      "cssls",
      "svelte",
      "lua_ls",
      "pyright",
      "clangd",
    }

    -- venv interpreter lives in .venv/bin/python on macOS/Linux, .venv\Scripts\python.exe on Windows
    local is_windows = vim.fn.has("win32") == 1
    local venv_python = vim.fn.getcwd() .. (is_windows and "/.venv/Scripts/python.exe" or "/.venv/bin/python")
    local has_venv_python = vim.uv.fs_stat(venv_python) ~= nil

    local server_configs = {
      svelte = {
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = { "*.js", "*.ts" },
            callback = function(ctx)
              -- Here use ctx.match instead of ctx.file
              client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
            end,
          })
        end,
      },
      lua_ls = {
        settings = {
          Lua = {
            -- make the language server recognize "vim" global
            diagnostics = {
              globals = { "vim" },
            },
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      },
      -- C/C++: whichever clangd is on PATH (Xcode on macOS, LLVM on Windows). Include paths come from a
      -- compile_commands.json in the project root (e.g. cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON).
      clangd = {
        cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=never" },
      },
      pyright = has_venv_python and {
        settings = {
          python = {
            pythonPath = venv_python,
          },
        },
      } or {},
    }

    for _, server in ipairs(servers) do
      local config = vim.tbl_deep_extend(
        "force",
        { capabilities = capabilities },
        server_configs[server] or {}
      )
      vim.lsp.config(server, config)
    end

    -- On a restricted machine, only enable servers whose binary is actually on PATH
    -- (e.g. a pyright that came through an approved Python/Node). Enabling one that is
    -- missing just logs spawn errors, so filter them out for a clean start.
    if require("martin.core.restricted").enabled() then
      local cmd_for = {
        ts_ls = "typescript-language-server",
        html = "vscode-html-language-server",
        cssls = "vscode-css-language-server",
        svelte = "svelteserver",
        lua_ls = "lua-language-server",
        pyright = "pyright-langserver",
        clangd = "clangd",
      }
      servers = vim.tbl_filter(function(s)
        return vim.fn.executable(cmd_for[s] or s) == 1
      end, servers)
    end

    vim.lsp.enable(servers)
  end,
}
