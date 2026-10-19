Keys I use day to day, for looking up while working. `⌃` Control · `⌥` Option · `⇧` Shift · `⌘` Command · `🌐` Globe/Fn · `␣` Space (Neovim leader).

- **macOS:** [[#Move window to a display|Displays]] · [[#Window tiling (macOS)|Tiling]] · [[#Raycast]] · [[#Windows and system|System]]
- **Apps:** [[#Finder]] · [[#Safari]] · [[#Vimlike (Safari)|Vimlike]] · [[#Mail]] · [[#Messages]] · [[#IINA (video)|IINA]]
- **Terminal:** [[#Ghostty]] · [[#Yazi]] · [[#tmux]] · [[#Herdr (trial)|Herdr]]
- **Vim:** [[#Moving]] · [[#Marks & jumps|Marks & jumps]] · [[#Editing]] · [[#Visual & search|Visual & search]] · [[#Files & clipboard|Files]] · [[#Folding]]
- **Neovim:** [[#Find & files|Find]] · [[#Code (LSP)|Code]] · [[#Error lists (Trouble)|Errors]] · [[#Git]] · [[#Debugging]] · [[#Windows & tabs|Windows & tabs]] · [[#Editing helpers|Editing]] · [[#Completion (insert)|Completion]] · [[#Notes (Obsidian)|Notes]] · [[#Sessions]]

## macOS

### Move window to a display

| Keys | Action |
|---|---|
| `⌃⌥⌘ ↑` | DELL (above) |
| `⌃⌥⌘ ↓` | Built-in (below) |

### Window tiling (macOS)

| Keys | Action |
|---|---|
| `⌃🌐 ← → ↑ ↓` | Split half |
| `⌃🌐 F` | Fill screen |
| `⌃🌐 C` | Centre |
| `🌐 F` | Fill as Desktop |

### Raycast

Commands run by name: type a few letters (`lh` finds Left Half), then `↵`.

| Keys | Action |
|---|---|
| `⌘ ␣` | Open Raycast (Spotlight: menu-bar icon) |
| `saf ↵` | Open an app by name (here Safari) |
| `search files ↵` | Find a file by name |
| `↵` · `⌘ ↵` | Open file · show it in Finder |
| `zoxide ↵` | Jump to a visited folder (fuzzy) |
| `↵` · `⌘ ↵` | Open folder in Finder · in the terminal |
| `⌘ K` | All actions for the selected item |
| `left half` · `right half` | Window to left / right half |
| `ftt` · `ltt` | First / last two-thirds |
| `make larger` · `make smaller` | Grow / shrink |
| `maximize` · `almost maximize` | Full screen · 90% |
| `center` | Centre the window |
| `restore` | Undo: previous size and position |
| `next display` | Move window to the other screen |

### Windows and system

| Keys | Action |
|---|---|
| `⌃⌘ F` | Full screen |
| `` ⌘ ` `` | Cycle windows |
| `⌘ M` | Minimise |
| `⌥⌘ M` | Minimise all |
| `Fn N` | Notification Center |

## Apps

### Finder

| Keys | Action |
|---|---|
| `⇧⌘ F` | Go to folder |
| `⇧⌘ R` | Recents |
| `⇧⌘ D` | Downloads |
| `⌥⌘ L` | Desktop |

### Safari

| Keys | Action |
|---|---|
| `⌘ [ ]` | Back / forward |
| `⌃ Tab` | Next tab |
| `⌃⇧ Tab` | Prev tab |
| `⌘ T / W` | New / close tab |
| `⇧⌘ T` | Reopen closed tab |
| `⌘ L` | Address bar |
| `⌘ R` | Reload |
| `⇧⌘ \` | Tab overview |

### Vimlike (Safari)

| Keys | Action |
|---|---|
| `j / k` | Scroll |
| `f / ⇧F` | Follow link / in new tab |
| `⇧H / ⇧L` | Back / forward |
| `q / w` | Prev / next tab |
| `?` | All keys |
| **Youtube site** | |
| `⌃I` | Insert mode |
| `Esc` | Exit insert mode |
| `⇧T` | Max screen width |

### Mail

| Keys | Action |
|---|---|
| `Fn ← →` | Start / end mailbox |
| `Fn ↑ ↓` | Page up / down |
| `⌃⌘ [ ]` | Prev / next mailbox |

### Messages

| Keys | Action |
|---|---|
| `⌃ tab` | Move down messages |
| `⌃ ⇧ tab` | Move up messages |

### IINA (video)

Default player for `.mp4` and `.mp3` (also from Neovim and Raycast). Keys: `config/iina/Martin.conf`.

| Keys | Action |
|---|---|
| `␣` | Play / pause |
| `h / l` | Back / forward 10 s |
| `← / →` | Back / forward 5 s |
| `⌥← / ⌥→` | One frame back / forward |
| `⌘[ / ⌘]` | Half / double speed (`⌘\` normal) |
| `⌥⌘[ / ⌥⌘]` | Speed −/+ 10% |
| `↑ / ↓` | Volume |
| `⌘← / ⌘→` | Previous / next file in playlist |

## Terminal

### Ghostty

| Keys | Action |
|---|---|
| `⌥⌘ ← →↑ ↓` | Activate pane |
| `⌃⌘ ← →↑ ↓` | Resize split |
| `⇧⌘ ← →↑ ↓` | New split |
| `⌘W` | Close pane |
| `⌘K` | Clear pane |
| `⌘ 1,2…` | Switch tab |
| `⇧⌘ ↩` | Max terminal |
| `⌘ ↩` | Full screen |

### Yazi

| Keys | Action |
|---|---|
| `z` | Fuzzy find (fzf) |
| `Z` | Frequent dirs (zoxide) |
| `s / S` | Search names / contents |
| `o / O` | Open / open with |
| `q` | Quit |

### tmux

Prefix `⌃a`, then the key — same on both machines. The multiplexer is `tmux` on the Mac and `psmux` on the work PC (a native Windows build; it also answers to `tmux` and `pmux`), so the `tmux …` commands below work on either.

| Keys | Action |
|---|---|
| `tmux new -s name` / `tmux attach` | New session / return to the last one |
| `⌃a d` | Detach (session keeps running) |
| `⌃a ⇧\` (bar) / `⌃a -` | Split side by side / one above the other |
| `⌃h ⌃j ⌃k ⌃l` | Move between panes and Neovim splits |
| `⌃a h j k l` | Resize pane (repeatable) |
| `⌃a m` | Zoom pane |
| `⌃a ⌃k` | Clear pane and scrollback (`⌘K` in tmux) |
| `⌃a c` | New window |
| `⌃a n / p` · `⌃a 0–9` | Next / previous window · go to window |
| `⌃a s` / `⌃a w` | Pick session / window |
| `⌃a [` then `v`, `y`, `q` | Scroll and copy (select, copy, quit) |
| `⌃a ]` | Paste tmux copy |
| `⌃a ⌃a` | Start of line (literal `⌃a`) |
| `⌃a r` · `⌃a ?` | Reload config · list keys |


### Herdr (trial)

Prefix `⌃a`, as in tmux. Start or return with `herdr`; `⌃a ?` lists every key. Clicking also works: panes to focus, borders to resize, the sidebar to switch.

| Keys | Action |
|---|---|
| `herdr` · `⌃a d` | Start / return · detach (keeps running) |
| `⌃a ?` · `⌃a s` · `⌃a r` | Key help · settings · reload config |
| `⌃a ⇧\` (bar) / `⌃a -` | Split side by side / one above the other |
| `⌃h ⌃j ⌃k ⌃l` | Move between panes and Neovim splits |
| `⌃a ← → ↑ ↓` · `⌃a Tab` | Move to pane · cycle panes |
| `⌃a h j k l` · `⌃a ⇧R` | Resize pane · resize mode |
| `⌃a ⇧H ⇧J ⇧K ⇧L` | Swap pane with its neighbour |
| `⌃a m` · `⌃a x` · `⌃a ⌃k` | Zoom · close pane · clear pane |
| `⌃a ⇧P` | Rename pane |
| `⌃a c` · `⌃a n / p` · `⌃a 1–9` | New tab · next / previous · go to tab |
| `⌃a ⇧T` · `⌃a ⇧X` | Rename tab · close tab |
| `⌃a ⇧N` · `⌃a w` | New workspace · workspace list (`↑ ↓` select, `h j k l` panes) |
| `⌃a ⇧W` · `⌃a ⇧D` | Rename workspace · close workspace |
| `⌃a g` | Session navigator: search workspaces, tabs and agents |
| `⌃a ,` / `⌃a .` · `⌃a ⌥1–9` | Previous / next agent · go to agent 1–9 |
| `⌃a o` | Jump to the agent that raised the latest notification |
| `⌃a b` | Show / hide the agent sidebar |
| `⌃a ⇧G` | New Git worktree for the workspace |
| `⌃a [` then `v`, `y` · `/` `n` | Copy mode: select, copy · search |
| `⌃a e` | Open the pane's scrollback in Neovim |

## Vim

### Moving

| Keys | Action |
|---|---|
| `h j k l` | Left / down / up / right |
| `w / b / e` | Next word / back / word end |
| `0 / ^ / $` | Line start / first char / end |
| `gg / G` | Top / bottom of file |
| `42G` | Line 42 (also `:42`) |
| `⇧H / ⇧M / ⇧L` | Top / middle / bottom of screen |
| `{ / }` | Paragraph up / down |
| `⌃d / ⌃u` | Half page down / up |
| `⌃f / ⌃b` | Full page down / up |
| `⌃e / ⌃y` | Scroll one line (cursor stays) |
| `zz / zt / zb` | Cursor line to middle / top / bottom |
| `%` | Toggle between a bracket and its match |
| `[( / ])` | Back / forward to enclosing ( ) |
| `[{ / ]}` | Back / forward to enclosing { } |
| `f x / t x` | To / before char x (; repeats) |

### Marks & jumps

| Keys | Action |
|---|---|
| `⌃o / ⌃i` | Back / forward through the jump list |
| `:jumps` | Show the jump list |
| `''` | Back to where the last jump started (and toggle) |
| `ma` | Save point a (lowercase: this file) |
| `'a` | To the line of point a |
| `` `a `` | To the exact spot of point a |
| `mA` | Save point A (uppercase: any file) |
| `'A` | Open A's file at A |
| `:marks` | List saved points |
| `:delm a` | Delete point a (`:delm!` all lowercase) |
| `` `. `` | Last change |
| `g; / g,` | Older / newer change |

### Editing

| Keys | Action |
|---|---|
| `i / a` | Insert before / after cursor |
| `I / A` | Insert at line start / end |
| `o / O` | New line below / above |
| `x / r` | Delete char / replace char |
| `dd / yy / p` | Cut line / copy line / paste |
| `ciw / cw` | Change inner word / to word end |
| `ci( / da{ / yi[` | Change inside ( ) / delete { } and all / copy inside [ ] |
| `u / ⌃r` | Undo / redo |
| `.` | Repeat last change |
| `>> / <<` | Indent / outdent |

### Visual & search

| Keys | Action |
|---|---|
| `v / V / ⌃v` | Char / line / block select |
| `/ ?` | Search forward / back |
| `n / N` | Next / previous match |
| `*` | Search word under cursor |
| `:%s/a/b/g` | Replace a with b everywhere |

### Files & clipboard

| Keys | Action |
|---|---|
| `:w / :q / :wq` | Save / quit / save and quit |
| `:q!` | Quit without saving |
| `"*y / "*p` | Copy to / paste from macOS |

### Folding

| Keys | Action |
|---|---|
| `za` | Toggle fold under cursor |
| `zc / zo` | Close / open fold |
| `zM / zR` | Close all / open all |
| `zr` | Reveal one more level |

## Neovim — this setup (␣ = Space)

### Find & files

| Keys | Action |
|---|---|
| `␣ff` | Find files |
| `␣fs` | Find text in project |
| `␣fr` | Recent files |
| `␣fc` | Find word under cursor |
| `␣ft` | Find TODOs |
| `␣fb` | Open buffers |
| `␣ee / ␣ef` | Explorer / reveal file |
| `␣ec / ␣er` | Collapse / refresh explorer |
| `l / →` · `h / ←` | Explorer: open folder or file · close folder |

### Code (LSP)

| Keys | Action |
|---|---|
| `gd / gD` | Definition / declaration |
| `gR` | References |
| `gi / gt` | Implementation / type |
| `K` | Docs under cursor |
| `␣rn` | Rename symbol |
| `␣ca` | Code action |
| `gl` | Error on this line |
| `[d / ]d` | Previous / next error |
| `␣D` | All errors in file |
| `␣rs` | Restart language server |
| `␣mp` | Format file (only way for C/C++) |
| `␣l` | Lint now |

### Error lists (Trouble)

| Keys | Action |
|---|---|
| `␣xd / ␣xw` | File / workspace errors |
| `␣xq / ␣xl` | Quickfix / location list |
| `␣xt` | TODOs |

### Git

| Keys | Action |
|---|---|
| `␣lg` | LazyGit |
| `]h / [h` | Next / previous hunk |
| `␣hp` | Preview hunk |
| `␣hs / ␣hr` | Stage / reset hunk |
| `␣hS / ␣hR` | Stage / reset file |
| `␣hu` | Undo stage hunk |
| `␣hb / ␣hB` | Blame line / toggle blame |
| `␣hd` | Diff this file |

### Debugging

| Keys | Action |
|---|---|
| `␣dc` | Start / continue |
| `␣db` | Toggle breakpoint |
| `␣do / ␣di` | Step over / into |
| `␣dO` | Step out |
| `␣dq` | Stop debugging |
| `␣du` | Debugger UI |

### Windows & tabs

| Keys | Action |
|---|---|
| `␣sv / ␣sh` | Split vertical / horizontal |
| `␣se / ␣sx` | Equalise / close split |
| `␣sm` | Maximise split |
| `⌃h j k l` | Move between splits |
| `␣to / ␣tx` | New / close tab |
| `␣tn / ␣tp` | Next / previous tab |
| `␣tr` | Rename tab |

### Editing helpers

| Keys | Action |
|---|---|
| `gcc / gc` | Comment line / motion |
| `ys / ds / cs` | Add / delete / change surround |
| `s / ss` | Replace with yanked text |
| `v  < / >` | Indent, keep selection |
| `v  ⌥k / ⌥j` | Move lines up / down (left ⌥) |
| `␣nh` | Clear search highlights |

### Completion (insert)

| Keys | Action |
|---|---|
| `⌃Space` | Show suggestions |
| `⌃j / ⌃k` | Next / previous suggestion |
| `⏎ / ⌃e` | Accept / close |

### Notes (Obsidian)

| Keys | Action |
|---|---|
| `␣oq / ␣os` | Switch note / search notes |
| `␣on / ␣od` | New note / daily note |
| `␣ob` | Backlinks |
| `⏎` | Follow link / tick checkbox |
| `]o / [o` | Next / previous link |
| `␣ok` | Open this Quick Reference |

### Sessions

| Keys | Action |
|---|---|
| `␣ws / ␣wr` | Save / restore session |
