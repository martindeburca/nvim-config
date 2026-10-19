-- Run tests from inside Neovim (pytest via neotest-python).
-- Results show as pass/fail signs beside each test; failures appear as
-- diagnostics. Tests run with the project's .venv Python (same lookup as
-- nvim-dap), and "debug nearest test" runs it under nvim-dap/debugpy.
-- Cross-platform: .venv/Scripts on Windows, .venv/bin on macOS.
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
  },
  keys = {
    { "<leader>Tt", function() require("neotest").run.run() end, desc = "Test: run nearest" },
    { "<leader>Tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test: run file" },
    { "<leader>Ta", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Test: run all (project)" },
    { "<leader>Tl", function() require("neotest").run.run_last() end, desc = "Test: run last" },
    { "<leader>Td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Test: debug nearest" },
    { "<leader>Tx", function() require("neotest").run.stop() end, desc = "Test: stop" },
    { "<leader>Ts", function() require("neotest").summary.toggle() end, desc = "Test: toggle summary" },
    { "<leader>To", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Test: show output" },
    { "<leader>TO", function() require("neotest").output_panel.toggle() end, desc = "Test: toggle output panel" },
    { "[T", function() require("neotest").jump.prev({ status = "failed" }) end, desc = "Test: previous failure" },
    { "]T", function() require("neotest").jump.next({ status = "failed" }) end, desc = "Test: next failure" },
  },
  config = function()
    local is_windows = vim.fn.has("win32") == 1

    -- Project .venv Python, searched upward from the test root; falls back to
    -- python on PATH ("python3" on macOS; on Windows "python3" can be a Store stub).
    local function venv_python(root)
      local venv = vim.fs.find(".venv", { path = root or vim.uv.cwd(), upward = true, type = "directory" })[1]
      if venv then
        local py = venv .. (is_windows and "/Scripts/python.exe" or "/bin/python")
        if vim.fn.executable(py) == 1 then return py end
      end
      local fallback = vim.fn.exepath(is_windows and "python" or "python3")
      return fallback ~= "" and fallback or "python"
    end

    require("neotest").setup({
      adapters = {
        require("neotest-python")({
          runner = "pytest",
          python = venv_python,
          dap = { justMyCode = false },
        }),
      },
      -- Failures as diagnostics plus a short inline message on the test line.
      diagnostic = { enabled = true },
      status = { virtual_text = true, signs = true },
      output = { open_on_run = false },
      quickfix = { enabled = false },
    })
  end,
}
