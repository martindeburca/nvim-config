-- Windows only: move Herdr's focus over its named pipe instead of the `herdr` CLI.
--
-- At a split edge the Herdr hand-off (plugins/init.lua) asks Herdr to focus the
-- neighbouring pane. On the managed Windows PC starting `herdr.exe` takes ~1.3 s (every
-- unsigned program is scanned at start), and vim.fn.system blocks Neovim for all of it.
-- Herdr serves its API on the named pipe `\\.\pipe\` .. HERDR_SOCKET_PATH, one JSON request
-- per line (as the jsheely/herdr-vim-navigation plugin uses it), so this sends the same
-- pane.focus_direction request through libuv: no process, no wait. If the pipe cannot be
-- opened, the CLI is started in the background instead.
local M = {}

function M.focus(dir, pane, herdr_bin)
  local function fallback()
    vim.fn.jobstart({ herdr_bin, "pane", "focus", "--direction", dir, "--pane", pane }, { detach = true })
  end
  local sock = vim.env.HERDR_SOCKET_PATH
  if not sock or sock == "" then
    return fallback()
  end
  local name = sock:sub(1, 9) == "\\\\.\\pipe\\" and sock or ("\\\\.\\pipe\\" .. sock)
  local request = vim.json.encode({
    id = "nvim-nav",
    method = "pane.focus_direction",
    params = { direction = dir, pane_id = pane },
  }) .. "\n"

  local pipe = vim.uv.new_pipe(false)
  pipe:connect(name, function(err)
    if err then
      pipe:close()
      vim.schedule(fallback)
      return
    end
    pipe:write(request)
    -- Herdr answers with one line; close once it arrives (or the pipe ends).
    pipe:read_start(function(read_err, data)
      if read_err or not data or data:find("\n") then
        pipe:read_stop()
        pipe:close()
      end
    end)
  end)
end

return M
