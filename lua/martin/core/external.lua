-- File types Neovim hands to another program instead of loading them as text.
-- One list, used by the BufReadCmd autocmd (martin.core.autocmds, which catches
-- :edit, nvim-tree, the command line, ...) and by Telescope's <CR>.
--
-- vim.ui.open uses the OS default application, so the usual associations apply:
-- `open` on macOS (e.g. MP4 -> QuickTime, images -> Preview), the Windows
-- default app on the work PC. Notebooks go to JupyterLab (martin.core.notebook).
-- Text formats that are sometimes "opened elsewhere" (svg, html, csv, json) are
-- deliberately left out: those are edited here.

local M = {}

M.extensions = {
  -- documents
  "pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx", "odt", "ods", "odp",
  "pages", "numbers", "key", "rtf", "epub",
  -- images
  "png", "jpg", "jpeg", "gif", "heic", "heif", "webp", "tif", "tiff", "bmp", "ico", "psd",
  -- video
  "mp4", "m4v", "mov", "mkv", "avi", "webm", "wmv",
  -- audio
  "mp3", "m4a", "wav", "aac", "flac", "ogg", "aiff", "aif",
  -- notebooks (JupyterLab)
  "ipynb",
}

local lookup = {}
for _, ext in ipairs(M.extensions) do
  lookup[ext] = true
end

-- autocmd patterns ("*.pdf", ...). macOS and Windows match file names ignoring case
-- ('fileignorecase'), so "*.mp4" also catches .MP4 from cameras; elsewhere add the
-- upper-case form too (adding it on macOS would fire the autocmd twice).
function M.patterns()
  local pats = {}
  for _, ext in ipairs(M.extensions) do
    table.insert(pats, "*." .. ext)
    if not vim.o.fileignorecase then
      table.insert(pats, "*." .. ext:upper())
    end
  end
  return pats
end

function M.is_external(path)
  local ext = type(path) == "string" and path:match("%.([^./\\]+)$")
  return ext ~= nil and lookup[ext:lower()] == true
end

-- Open path outside Neovim; returns ok, err.
function M.open(path)
  path = vim.fn.fnamemodify(path, ":p")
  if path:lower():match("%.ipynb$") then
    return pcall(require("martin.core.notebook").open, path)
  end
  -- vim.ui.open reports a failure (no handler) by returning nil, err rather than raising
  local ok, obj, err = pcall(vim.ui.open, path)
  if not ok then
    return false, obj
  end
  return obj ~= nil, err
end

return M
