# archminimal-setup

One command to set up the whole archminimal environment on a fresh Arch Linux machine (and the shell and
editor parts on macOS). It clones the component repos and runs each one's own installer in the right order.

| Repo | What it sets up | Arch | macOS |
|---|---|---|---|
| [`zsh`](https://github.com/NobodyOne04/zsh) | fast zsh with p10k prompt, fzf, devops helpers | ✓ | ✓ |
| [`tmux`](https://github.com/NobodyOne04/tmux) | tmux: Alt-key navigation shared with nvim, project sessions, popups, sessions that survive reboots | ✓ | ✓ |
| [`nvim`](https://github.com/NobodyOne04/nvim) | Neovim: LSP, treesitter, telescope, completion, Copilot | ✓ | ✓ |
| [`archminimal-hypr`](https://github.com/NobodyOne04/archminimal-hypr) | Hyprland desktop: bar, launcher, lock, idle, kitty | ✓ | |
| [`archminimal-greeter`](https://github.com/NobodyOne04/archminimal-greeter) | login screen: greetd + Quickshell greeter (no SDDM) | ✓ | |

Plus the toolchains, installed by `bin/setup` itself:

| Step | What it installs | Arch | macOS |
|---|---|---|---|
| `python` | Python + [uv](https://docs.astral.sh/uv/) (projects, venvs, CLI tools, other Python versions) | pacman | brew |
| `go` | Go (`GOPATH` is `~/go`; `~/go/bin` is on PATH via the zsh repo) | pacman | brew |
| `claude` | [Claude Code](https://code.claude.com/docs/en/setup) CLI, official installer, updates itself | ✓ | ✓ |

## Fresh Arch install

From a TTY on a freshly installed Arch (with a user that has sudo):

```bash
sudo pacman -S --needed git make openssh
# the repos are private: give this machine a GitHub SSH key
ssh-keygen -t ed25519 && cat ~/.ssh/id_ed25519.pub   # add it at https://github.com/settings/ssh/new

# the repos live in /opt/archminimal, outside home (owned by you and private to you; no sudo after this)
sudo install -d -m 0700 -o "$USER" -g "$(id -gn)" /opt/archminimal
git clone git@github.com:NobodyOne04/archminimal-setup.git /opt/archminimal/archminimal-setup
cd /opt/archminimal/archminimal-setup
make doctor     # checks tools and GitHub access, shows the plan
make all        # snapshot of /, base packages, repos, zsh, python, go, nvim, claude, desktop, login screen, remove SDDM
reboot          # the archminimal login screen starts Hyprland
```

`make all` asks for your sudo password and confirms each pacman install. Add `DRY_RUN=1` to any target to see
every command without running it, e.g. `make all DRY_RUN=1`.

## Moving from ~/projects

Machines set up before the repos moved to `/opt/archminimal` (ADR-0007): from a TTY (or restart the bar after),

```bash
cd ~/projects/archminimal-setup && git pull && make migrate
```

It moves every clone (uncommitted work included), relinks the configs in home, moves this repo last and leaves
`~/projects` to delete.

## Everyday

| Command | What |
|---|---|
| `make status` | each repo's branch, unpushed or uncommitted work, whether its links are in place; tool versions |
| `make update` | pull every repo (fast-forward only; repos with local changes are left alone), update plugins |
| `make check` | run each repo's own checks (zsh startup, nvim startup, Hyprland and greeter lint) |
| `make zsh` / `tmux` / `python` / `go` / `nvim` / `claude` / `desktop` | (re)install one part |
| `make snapshot` | read-only btrfs snapshot of `/` without `/home`, in `snapshots/` at the top of the filesystem (`LABEL=name` to tag it) |
| `make remove-sddm` | after the greeter step: snapshot `/`, then remove SDDM completely (packages, config, state, logs, the `sddm` user, `~/.local/share/sddm`) |
| `make ssh-key` | create a key if missing and show where to add it |
| `make packages` | macOS: install everything in the `Brewfile` |
| `make packages-check` / `packages-clean` | macOS: list / remove packages that are installed but not in the `Brewfile` |

## How it works

- `bin/setup` does the work; the Makefile only forwards to it (`./bin/setup --help` lists the commands).
- Repos live in `/opt/archminimal` (`PROJECTS=...` to change), outside home: everything in home is a link into it
  or a rebuildable cache, so home can be wiped and `make all` puts it back. An existing clone is found by its `origin` URL, so a repo
  cloned under another folder name is reused, never cloned twice.
- Every component installs through its own `Makefile`, so each repo also works on its own.
- Nothing is overwritten: the component installers move existing configs to `*.bak-<date>` and can restore them
  (`make -C /opt/archminimal/zsh unlink`, `make -C /opt/archminimal/nvim unlink`, `make -C /opt/archminimal/archminimal-hypr uninstall`,
  `sudo make -C /opt/archminimal/archminimal-greeter revert`).
- Credentials never go into these repos. The zsh installer moves any keys found in an old `~/.zshrc` into
  `~/.config/zsh/secrets.zsh` (mode 600); add new ones with `secret-add NAME`.

## Order of `make all`

1. **doctor**: git, make, curl, ssh, GitHub access, where each repo will live
   **snapshot**: read-only btrfs snapshot of `/` without `/home` (`snapshots/root-<date>-pre-setup-all`); skipped when `/` is not btrfs
2. **base**: `pacman -Syu --needed git make base-devel openssh curl`
3. **repos**: clone or fast-forward `zsh`, `tmux`, `nvim`, `archminimal-hypr`, `archminimal-greeter` (a clone made
   before a repo was renamed is found under its old name and pointed at the new one)
4. **zsh**: tools, link `~/.zshrc`, make zsh the login shell
   **tmux**: tools, link `~/.config/tmux`, plugins
5. **python**: `pacman -S --needed python uv`
6. **go**: `pacman -S --needed go` (before nvim: its language servers such as gopls are built with it)
7. **nvim**: tools, link `~/.config/nvim`, plugins at locked versions, language servers
8. **claude**: Claude Code via Anthropic's installer into `~/.local/bin/claude`; skipped if already installed.
   It updates itself; run `claude` in a project folder and log in in the browser the first time
9. **desktop**: Hyprland packages, Bluetooth and power-profile services, config links; asks whether to install the camera kill
   switch (`make privacy`: a root helper + polkit rule; `make update` warns when it is out of date)
10. **greeter**: greetd + the Quickshell login screen. It takes over from whatever display manager is active
   (archinstall's Hyprland profile installs SDDM) and records it, so `sudo make -C /opt/archminimal/archminimal-greeter revert`
   can undo it.
11. **remove-sddm**: lists what is left of SDDM and, once you confirm, removes it completely (packages and their
   cached downloads, config, state, logs, the `sddm` user); the snapshot from step 1 is the way back. Nothing to do on a machine without SDDM
