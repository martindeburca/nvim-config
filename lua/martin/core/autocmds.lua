-- Open non-text files (PDFs, video, images, Office files, ...) in the OS default
-- application instead of loading their binary contents into a Neovim buffer.
-- Uses vim.ui.open, so it respects the system default handler (QuickTime for MP4
-- on macOS, and so on). Triggered on BufReadCmd, so it catches every entry point
-- (Telescope, nvim-tree, :edit, the command line, ...) before Neovim reads the file.
-- Jupyter notebooks (*.ipynb) are opened in JupyterLab via martin.core.notebook.

-- The list of extensions lives in martin.core.external; add new types there.
local external = require("martin.core.external")
local external_patterns = external.patterns()

local group = vim.api.nvim_create_augroup("MartinOpenExternally", { clear = true })

vim.api.nvim_create_autocmd("BufReadCmd", {
  group = group,
  pattern = external_patterns,
  callback = function(ev)
    local ok, err = external.open(ev.file)
    if not ok then
      vim.notify("Could not open " .. ev.file .. " externally: " .. tostring(err), vim.log.levels.ERROR)
    end
    -- Return to the buffer we came from, then discard the empty buffer, so
    -- opening an external file doesn't leave a blank buffer behind. If there was no prior
    -- buffer (e.g. straight after launch), the empty buffer is the natural state.
    vim.schedule(function()
      local alt = vim.fn.bufnr("#")
      if alt > 0 and alt ~= ev.buf and vim.api.nvim_buf_is_valid(alt) then
        pcall(vim.api.nvim_set_current_buf, alt)
      end
      if vim.api.nvim_buf_is_valid(ev.buf) then
        pcall(vim.api.nvim_buf_delete, ev.buf, { force = true })
      end
    end)
  end,
})

-- When the last real (listed, named) buffer is closed, show the alpha dashboard
-- ("Neovim menu") instead of dropping to a blank [No Name] buffer. This also
-- covers the PDF case above: opening a PDF externally from the dashboard returns
-- you to the dashboard rather than an empty buffer.
vim.api.nvim_create_autocmd("BufDelete", {
  group = vim.api.nvim_create_augroup("MartinDashboardOnEmpty", { clear = true }),
  callback = function()
    vim.schedule(function()
      for _, b in ipairs(vim.api.nvim_list_bufs()) do
        if
          vim.api.nvim_buf_is_loaded(b)
          and vim.bo[b].buflisted
          and vim.api.nvim_buf_get_name(b) ~= ""
        then
          return -- a real buffer is still open; leave things as they are
        end
      end
      pcall(function()
        require("alpha").start(false)
      end)
    end)
  end,
})
