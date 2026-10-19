vim.cmd("let g:netrw_liststyle = 3")

-- TLS-proxy fix: nvim-treesitter (main) downloads parser sources with curl,
-- whose TLS revocation check fails behind TLS-inspecting proxies
-- (CRYPT_E_NO_REVOCATION_CHECK). Point CURL_HOME at a Neovim-local .curlrc holding
-- `ssl-no-revoke`, so ONLY curl spawned by Neovim skips the check -- global curl,
-- git and the shell are unaffected. `ssl-no-revoke` is a no-op on macOS's TLS
-- backend, so this is safe cross-platform.
vim.env.CURL_HOME = vim.fn.stdpath("config") .. "/curl"

local opt = vim.opt -- for conciseness

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- line wrapping
opt.wrap = false

-- keep 3 lines visible above/below the cursor (H and L stop 3 lines from the edge)
opt.scrolloff = 3

-- search settings
opt.ignorecase = true
opt.smartcase = true

-- cursor line
opt.cursorline = true

-- appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true
opt.splitbelow = true

opt.iskeyword:append("-")

-- allow block insert at line start
opt.virtualedit = "block"

-- turn off swapfile
opt.swapfile = false

-- folding: Treesitter-based (JSON objects/arrays, functions, etc.)
-- files open fully unfolded; use za / zc / zo / zM / zR to fold
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99
