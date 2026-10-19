# nvim-config

My Neovim configuration: [lazy.nvim](https://github.com/folke/lazy.nvim) with Telescope, nvim-tree,
Treesitter, LSP via Mason, and a built-in quick reference (`docs/quick-reference.md`).

This is a read-only mirror of the `config/nvim` folder in my private configs repo, updated
automatically. Edits made here are overwritten.

## Install on Windows

1. Point git at the Windows certificate store and skip the revocation check, which fails
   behind TLS-inspecting proxies (only needed once):

   ```
   git config --global http.sslBackend schannel
   git config --global http.schannelCheckRevoke false
   ```

2. Clone into Neovim's config folder:

   ```
   git clone https://github.com/martindeburca/nvim-config %LOCALAPPDATA%\nvim
   ```

   Without git: download the zip (Code → Download ZIP) and extract the **contents** of
   `nvim-config-main` into `%LOCALAPPDATA%\nvim`, so that `init.lua` sits directly inside it.

3. Start `nvim`. lazy.nvim installs itself and the plugins on first start, at the versions
   pinned in `lazy-lock.json`. curl's revocation check is already turned off for Neovim
   (`curl/.curlrc`, via `CURL_HOME` in `lua/martin/core/options.lua`).

## macOS / Linux

```
git clone https://github.com/martindeburca/nvim-config ~/.config/nvim
```

## Updating

```
git -C %LOCALAPPDATA%\nvim pull
```

then in Neovim `:Lazy restore` to match the pinned plugin versions.

## Optional tools

- A C compiler (Zig, MSVC Build Tools, or clang) for Treesitter parsers; without one,
  highlighting falls back to Vim's regex syntax.
- `make`, for telescope-fzf-native and LuaSnip's regex support; both are skipped when absent.
- `ripgrep` for Telescope's live grep.
