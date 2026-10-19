-- Open Jupyter notebooks (.ipynb) in JupyterLab in the browser instead of
-- loading their JSON into a Neovim buffer.
--
-- * Project root: the nearest ancestor containing a .venv, else the git root,
--   else the notebook's own directory.
-- * Jupyter: <root>/.venv's jupyter if present (so the kernel sees the
--   project's packages), else `jupyter` on PATH.
-- * If a Jupyter server already serving a parent folder is running, the
--   notebook is opened in it (no second server); otherwise a new JupyterLab
--   server is started, detached, rooted at the project, and opens the browser
--   itself. The server outlives Neovim; stop it from JupyterLab
--   (File > Shut Down) or with `jupyter server stop`.
-- Cross-platform: handles both Windows (.venv/Scripts) and Unix (.venv/bin).

local M = {}

local is_windows = vim.fn.has("win32") == 1

local function norm(p)
  p = vim.fs.normalize(p)
  return is_windows and p:lower() or p
end

local function project_root(file)
  local dir = vim.fs.dirname(file)
  local venv = vim.fs.find(".venv", { path = dir, upward = true, type = "directory" })[1]
  if venv then return vim.fs.dirname(venv) end
  local git = vim.fs.find(".git", { path = dir, upward = true })[1]
  if git then return vim.fs.dirname(git) end
  return dir
end

local function find_jupyter(root)
  local venv_jupyter = root .. (is_windows and "/.venv/Scripts/jupyter.exe" or "/.venv/bin/jupyter")
  if vim.uv.fs_stat(venv_jupyter) then return venv_jupyter end
  local global = vim.fn.exepath("jupyter")
  if global ~= "" then return global end
  return nil
end

-- Percent-encode a relative path for a /lab/tree/ URL, keeping the slashes.
local function url_path(rel)
  return (rel:gsub("[^%w%-%._~/]", function(c)
    return string.format("%%%02X", c:byte())
  end))
end

-- Is `file` inside `dir`? (both normalised)
local function is_under(file, dir)
  dir = dir:gsub("/$", "")
  return file:sub(1, #dir + 1) == dir .. "/"
end

-- Default JupyterLab to its dark theme by writing the per-user theme setting
-- (~/.jupyter/lab/user-settings/..., the same path on Windows and macOS).
-- Theme: "JupyterLab Night" (pip package jupyterlab-night, from
-- jupyterlab-contrib), with larger fonts than JupyterLab's 13px defaults and
-- the terminal font (JetBrainsMono Nerd Font) for code. Only created if absent, so changes made
-- later in JupyterLab (Settings > Theme) are kept.
local theme_settings = {
  "{",
  '  "theme": "JupyterLab Night",',
  '  "overrides": {',
  [[    "code-font-family": "'JetBrainsMono NF', 'JetBrainsMono Nerd Font', 'JetBrains Mono', Menlo, Consolas, monospace",]],
  '    "code-font-size": "15px",',
  '    "content-font-size1": "15px",',
  '    "ui-font-size1": "14px"',
  "  }",
  "}",
}

local function ensure_theme_settings()
  local dir = (vim.env.JUPYTERLAB_SETTINGS_DIR or (vim.fn.expand("~") .. "/.jupyter/lab/user-settings"))
    .. "/@jupyterlab/apputils-extension"
  local file = dir .. "/themes.jupyterlab-settings"
  if vim.uv.fs_stat(file) then return end
  vim.fn.mkdir(dir, "p")
  vim.fn.writefile(theme_settings, file)
end

-- Command (run from the project root) that installs packages into its .venv:
-- uv if available (much faster), else the venv's own pip.
local function install_cmd(pkgs)
  if vim.fn.executable("uv") == 1 then
    return "uv pip install --python .venv " .. pkgs
  end
  return (is_windows and ".venv\\Scripts\\pip" or ".venv/bin/pip") .. " install " .. pkgs
end

-- JupyterLab falls back to its light theme if the configured theme is not
-- installed, so point out a project venv that lacks jupyterlab-night.
local function check_theme_installed(root, jupyter)
  if not jupyter:find("/.venv/", 1, true) then return end
  if not vim.uv.fs_stat(root .. "/.venv/share/jupyter/labextensions/jupyterlab-night") then
    vim.notify("Night theme not installed in this venv (JupyterLab will be light): "
      .. install_cmd("jupyterlab-night"), vim.log.levels.WARN)
  end
end

function M.open(path)
  local file = vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
  local root = project_root(file)
  local jupyter = find_jupyter(root)
  if not jupyter then
    vim.notify(
      "No Jupyter found for " .. root .. ".\nInstall it in the project venv: "
        .. install_cmd("jupyterlab jupyterlab-night"),
      vim.log.levels.WARN
    )
    return
  end

  ensure_theme_settings()
  check_theme_installed(root, jupyter)

  -- `jupyter server list` alone can take several seconds (Python start-up,
  -- plus Defender scanning on managed Windows), so acknowledge immediately.
  vim.notify("Opening " .. vim.fs.basename(file) .. " in Jupyter...")

  -- Reuse a running server whose root contains the notebook, if there is one.
  vim.system({ jupyter, "server", "list", "--json" }, { text = true }, function(res)
    local reuse
    for line in (res.stdout or ""):gmatch("[^\r\n]+") do
      local ok, srv = pcall(vim.json.decode, line)
      if ok and type(srv) == "table" and srv.root_dir and srv.url
        and is_under(norm(file), norm(srv.root_dir)) then
        reuse = srv
        break
      end
    end

    vim.schedule(function()
      if reuse then
        local rel = file:sub(#vim.fs.normalize(reuse.root_dir):gsub("/$", "") + 2)
        local base = reuse.url:sub(-1) == "/" and reuse.url or (reuse.url .. "/")
        local url = base .. "lab/tree/" .. url_path(rel)
        if reuse.token and reuse.token ~= "" then url = url .. "?token=" .. reuse.token end
        vim.ui.open(url)
        vim.notify("Opened in running Jupyter server: " .. rel)
      else
        local rel = file:sub(#root + 2)
        -- stdout/stderr ignored (not piped) so the detached server is not
        -- tied to Neovim and keeps running after Neovim exits.
        -- root_dir must be explicit: given a file, Jupyter otherwise roots the
        -- server at the notebook's own folder rather than the project.
        vim.system({ jupyter, "lab", "--ServerApp.root_dir=" .. root, rel },
          { cwd = root, detach = true, stdout = false, stderr = false })
        vim.notify("Starting JupyterLab in " .. root .. " (" .. rel .. ")")
      end
    end)
  end)
end

return M
