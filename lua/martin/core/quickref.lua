-- Keep the keyboard-shortcuts Quick Reference open in its own tab ("Quick Ref").
-- Opens at startup as the second tab; you land in the first tab as normal.
-- The page lives in this config (docs/quick-reference.md), so it is on every machine
-- that pulls the config. Neovim is its only home (it is not in the Obsidian vault).

local path = vim.fn.stdpath("config") .. "/docs/quick-reference.md"
if vim.fn.filereadable(path) == 0 then
  return
end
local real_path = vim.fn.resolve(path)

-- <leader>ok jumps to it from anywhere
vim.keymap.set("n", "<leader>ok", function()
  vim.cmd("edit " .. vim.fn.fnameescape(path))
end, { desc = "Open the keyboard shortcuts Quick Reference" })

local group = vim.api.nvim_create_augroup("MartinQuickRef", { clear = true })

-- Neovim is sometimes used as a tool rather than an editor; don't add a tab then.
local started_with_stdin = false
vim.api.nvim_create_autocmd("StdinReadPre", {
  group = group,
  callback = function()
    started_with_stdin = true
  end,
})

local function wanted()
  if #vim.api.nvim_list_uis() == 0 then
    return false -- headless / scripted
  end
  if vim.o.diff or started_with_stdin then
    return false -- nvim -d, or reading stdin (e.g. as a pager)
  end
  for _, arg in ipairs(vim.fn.argv()) do
    local name = vim.fn.fnamemodify(arg, ":t")
    if
      name == "COMMIT_EDITMSG"
      or name == "MERGE_MSG"
      or name == "TAG_EDITMSG"
      or name == "git-rebase-todo"
      or name:match("^%.git")
    then
      return false -- Git asked Neovim to edit a message
    end
    if vim.fn.resolve(vim.fn.fnamemodify(arg, ":p")) == real_path then
      return false -- opened the page itself; it is already in front of you
    end
  end
  return true
end

local function is_quickref(buf)
  return vim.fn.resolve(vim.api.nvim_buf_get_name(buf)) == real_path
end

-- Contents links at the top of the page are [[#Heading|label]]. Return on one jumps to
-- that heading. Elsewhere Return behaves normally.
local function jump_to_section()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local start = 1
  while true do
    local s, e, heading = line:find("%[%[#([^|%]]+)[^%]]*%]%]", start)
    if not s then
      break
    end
    if col >= s and col <= e then
      for lnum, text in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
        if text:match("^#+%s+(.-)%s*$") == heading then
          vim.cmd("normal! m'") -- so Ctrl-o jumps back to the contents
          vim.api.nvim_win_set_cursor(0, { lnum, 0 })
          vim.cmd("normal! zt") -- put the section at the top of the window
          return
        end
      end
      return
    end
    start = e + 1
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
end

vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  callback = function(ev)
    if is_quickref(ev.buf) then
      vim.keymap.set("n", "<CR>", jump_to_section, { buffer = ev.buf, desc = "Jump to section" })
    end
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = group,
  nested = true, -- let FileType autocmds (render-markdown, obsidian) run for the new buffer
  callback = function()
    if not wanted() then
      return
    end
    vim.schedule(function()
      local home = vim.api.nvim_get_current_tabpage()
      vim.cmd("$tabnew " .. vim.fn.fnameescape(path))
      -- unlisted: doesn't count as an open file (so the start screen still appears
      -- when you close your last real file) and stays out of buffer pickers
      vim.bo.buflisted = false
      vim.t.tabname = "Quick Ref" -- label shown by bufferline (see bufferline.lua)
      vim.api.nvim_set_current_tabpage(home)
      vim.cmd("redrawtabline")
    end)
  end,
})

-- If closing a tab leaves only the Quick Reference, quit instead of sitting on it.
vim.api.nvim_create_autocmd("TabClosed", {
  group = group,
  callback = function()
    vim.schedule(function()
      local tabs = vim.api.nvim_list_tabpages()
      if #tabs ~= 1 then
        return
      end
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabs[1])) do
        if not is_quickref(vim.api.nvim_win_get_buf(win)) then
          return
        end
      end
      pcall(vim.cmd, "qa") -- plain :qa, so unsaved edits to the page still stop the quit
    end)
  end,
})
