-- "Restricted" machines: locked-down client PCs where application control (AppLocker /
-- WDAC) blocks downloaded executables, so Mason's language servers and formatters cannot
-- run, and there is usually no compiler for Treesitter parsers.
--
-- When enabled, Neovim stops TRYING to fetch or build those tools, so it starts clean and
-- uses only what is already installed and approved. It does not work around anything:
-- a server that is not present simply is not enabled; highlighting falls back to Vim's
-- built-in syntax where no parser exists. Editing, motions, Telescope file finding, git
-- signs, completion from buffers, sessions and the Quick Reference all work as normal.
--
-- Turn on, on that machine only, with either:
--   setx NVIM_RESTRICTED 1      (then open a new shell)
--   or create an empty file:  <nvim config dir>/restricted
-- The Mac and the other PC leave it unset, so they are unaffected.
local M = {}

function M.enabled()
  local env = vim.env.NVIM_RESTRICTED
  if env and env ~= "" and env ~= "0" then
    return true
  end
  return vim.uv.fs_stat(vim.fn.stdpath("config") .. "/restricted") ~= nil
end

return M
