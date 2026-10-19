# Windows setup (locked-down machines)

Tomorrow's checklist for getting this config running on a restricted client PC, in order.
Commands are for **Command Prompt** (`cmd`); adjust paths if your profile differs.

## 0. Prerequisites

- **Neovim** — from the company store.
- **git** — from the company store. Needed because lazy.nvim installs plugins with git.

Until git is approved you can still get the files: on the repo's GitHub page, **Code →
Download ZIP**, and extract the contents into `%LOCALAPPDATA%\nvim` (so `init.lua` sits
directly inside it). Plugins won't install without git, so this is editor-only.

## 1. Point git at the Windows cert store

Behind a TLS-inspecting proxy, git's revocation check fails. Run once:

```
git config --global http.sslBackend schannel
git config --global http.schannelCheckRevoke false
```

If git still rejects the proxy's certificate, ask IT for the root CA as a `.pem` and:

```
git config --global http.sslCAInfo "C:\path\to\company-root-ca.pem"
```

## 2. Clone the config

```
ren "%LOCALAPPDATA%\nvim" nvim-zip     & rem only if a ZIP copy is already there
git clone https://github.com/martindeburca/nvim-config "%LOCALAPPDATA%\nvim"
```

## 3. If this machine blocks downloaded executables

If application control blocks unapproved programs, turn on **restricted mode** so Neovim
doesn't try to download language servers (Mason) or compile parsers (Treesitter) — it
starts clean and uses only what's already approved and present:

```
setx NVIM_RESTRICTED 1
```

Open a **new** `cmd` afterwards. (Equivalently, create an empty file
`%LOCALAPPDATA%\nvim\restricted`.)

What still works in restricted mode: editing, motions, Telescope **file** finding, git
signs, buffer/path completion, sessions, the Quick Reference. Syntax highlighting falls
back to Vim's built-in where no Treesitter parser is present. A language server only
attaches if its binary is already on `PATH` (e.g. a `pyright-langserver` that arrived
with an approved Python/Node). `ripgrep` on `PATH` enables Telescope live-grep.

## 4. First launch

```
nvim
```

lazy.nvim installs itself and the plugins at the versions pinned in `lazy-lock.json`.
Expect some one-time build noise (Treesitter / fzf-native) where no compiler exists —
harmless. Restart Neovim once installs settle. Update later with
`git -C "%LOCALAPPDATA%\nvim" pull` then `:Lazy restore`.

## 5. PyCharm + IdeaVim (the no-new-binary fallback)

When you mostly want the editing model and PyCharm's own language features:

1. PyCharm → **Settings → Plugins → IdeaVim** (by JetBrains). Install, restart.
2. Create `%USERPROFILE%\.ideavimrc` containing one line:

   ```
   source ~/AppData/Local/nvim/ideavimrc
   ```

   That sources the `ideavimrc` in this repo, so it updates with `git pull`.
3. Reload with the IDE's **Reload .ideavimrc** action. Your leader keys, motions and the
   `jk`→Esc mapping now work in PyCharm, wired to PyCharm's find/usages/rename/debug.

## 6. Claude Code with a company API key (when issued)

Ask IT how they want it installed — ideally packaged for the company store, or run under
an approved Node.js. Then, in a new `cmd`:

```
setx ANTHROPIC_API_KEY "...key from IT..."
```

If it hits the proxy's certificate, set the CA IT provides:

```
setx NODE_EXTRA_CA_CERTS "C:\path\to\company-root-ca.pem"
```

Keep the key out of any repo (same rule as the Mac's secrets file). In PyCharm, install
the **Claude Code** plugin and run `claude` in the built-in terminal; it connects to the
IDE automatically.
