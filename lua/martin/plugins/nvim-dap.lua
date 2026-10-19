return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
	  "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local dap_python = require("dap-python")

      require("dapui").setup({})
      require("nvim-dap-virtual-text").setup({
        commented = true, -- Show virtual text alongside comment
      })

      -- Prefer project-local .venv relative to the current file.
      -- This avoids relying on Neovim's current working directory.
      local function find_venv_dir(startpath)
        if vim.fs and vim.fs.find then
          return vim.fs.find(".venv", { path = startpath, upward = true, type = "directory" })[1]
        end

        local found = vim.fn.finddir(".venv", startpath .. ";")
        return found ~= "" and found or nil
      end

      local is_windows = vim.fn.has("win32") == 1
      -- On Windows "python3" is often a Microsoft Store stub, so use "python" there.
      local default_python = is_windows and "python" or "python3"

      local function resolve_python()
        local bufname = vim.api.nvim_buf_get_name(0)
        local startpath = bufname ~= "" and vim.fn.fnamemodify(bufname, ":p:h") or vim.fn.getcwd()

        local venv_dir = find_venv_dir(startpath)
        if venv_dir then
          local python = venv_dir .. (is_windows and "/Scripts/python.exe" or "/bin/python")
          if vim.fn.executable(python) == 1 then
            return python
          end
        end

        local py = vim.fn.exepath(default_python)
        return py ~= "" and py or default_python
      end

      -- Keep dap-python loaded, but override adapter/config to be dynamic.
      dap_python.setup(default_python)

      dap.adapters.python = function(callback, _)
        callback({
          type = "executable",
          command = resolve_python(),
          args = { "-m", "debugpy.adapter" },
        })
      end

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = resolve_python,
        },
      }

      vim.fn.sign_define("DapBreakpoint", {
        text = "",
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
      })

      vim.fn.sign_define("DapBreakpointRejected", {
        text = "", -- or "❌"
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
      })

      vim.fn.sign_define("DapStopped", {
        text = "", -- or "→"
        texthl = "DiagnosticSignWarn",
        linehl = "Visual",
        numhl = "DiagnosticSignWarn",
      })

      -- Automatically open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end

      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end

      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      local opts = { noremap = true, silent = true }

      -- Toggle breakpoint
      vim.keymap.set("n", "<leader>db", function()
        dap.toggle_breakpoint()
      end, opts)

      -- Continue / Start
      vim.keymap.set("n", "<leader>dc", function()
        dap.continue()
      end, opts)

      -- Step Over
      vim.keymap.set("n", "<leader>do", function()
        dap.step_over()
      end, opts)

      -- Step Into
      vim.keymap.set("n", "<leader>di", function()
        dap.step_into()
      end, opts)

      -- Step Out
      vim.keymap.set("n", "<leader>dO", function()
        dap.step_out()
      end, opts)
			
      -- Keymap to terminate debugging
	  vim.keymap.set("n", "<leader>dq", function()
	      require("dap").terminate()
      end, opts)

      -- Toggle DAP UI
      vim.keymap.set("n", "<leader>du", function()
        dapui.toggle()
      end, opts)
    end,
  },
}

