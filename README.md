# linux_setup

One command to set up the whole archminimal environment on a fresh Arch Linux machine (and the shell and
editor parts on macOS). It clones the component repos and runs each one's own installer in the right order.

| Repo | What it sets up | Arch | macOS |
|---|---|---|---|
| [`zsh`](https://github.com/NobodyOne04/zsh) | fast zsh with p10k prompt, fzf, devops helpers | ✓ | ✓ |
| [`tmux`](https://github.com/NobodyOne04/tmux) | tmux: Alt-key navigation shared with nvim, project sessions, popups, sessions that survive reboots | ✓ | ✓ |
| [`nvim`](https://github.com/NobodyOne04/nvim) | Neovim: LSP, treesitter, telescope, completion, Copilot | ✓ | ✓ |
| [`hyprland`](https://github.com/NobodyOne04/hyprland) | Hyprland desktop: bar, launcher, lock, idle, kitty | ✓ | |
| [`sddm-login`](https://github.com/NobodyOne04/sddm-login) | login screen: greetd + Quickshell greeter (no SDDM) | ✓ | |

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

git clone git@github.com:NobodyOne04/linux_setup.git ~/projects/linux_setup
cd ~/projects/linux_setup
make doctor     # checks tools and GitHub access, shows the plan
make all        # base packages, repos, zsh, python, go, nvim, claude, desktop, login screen
reboot          # the archminimal login screen starts Hyprland
```

`make all` asks for your sudo password and confirms each pacman install. Add `DRY_RUN=1` to any target to see
every command without running it, e.g. `make all DRY_RUN=1`.

## Everyday

| Command | What |
|---|---|
| `make status` | each repo's branch, unpushed or uncommitted work, whether its links are in place; tool versions |
| `make update` | pull every repo (fast-forward only; repos with local changes are left alone), update plugins |
| `make check` | run each repo's own checks (zsh startup, nvim startup, Hyprland and greeter lint) |
| `make zsh` / `tmux` / `python` / `go` / `nvim` / `claude` / `desktop` | (re)install one part |
| `make ssh-key` | create a key if missing and show where to add it |
| `make packages` | macOS: install everything in the `Brewfile` |
| `make packages-check` / `packages-clean` | macOS: list / remove packages that are installed but not in the `Brewfile` |

## How it works

- `bin/setup` does the work; the Makefile only forwards to it (`./bin/setup --help` lists the commands).
- Repos live in `~/projects` (`PROJECTS=...` to change). An existing clone is found by its `origin` URL, so a repo
  cloned under another folder name is reused, never cloned twice.
- Every component installs through its own `Makefile`, so each repo also works on its own.
- Nothing is overwritten: the component installers move existing configs to `*.bak-<date>` and can restore them
  (`make -C ~/projects/zsh unlink`, `make -C ~/projects/nvim unlink`, `make -C ~/projects/hyprland uninstall`,
  `sudo make -C ~/projects/sddm-login revert`).
- Credentials never go into these repos. The zsh installer moves any keys found in an old `~/.zshrc` into
  `~/.config/zsh/secrets.zsh` (mode 600); add new ones with `secret-add NAME`.

## Order of `make all`

1. **doctor**: git, make, curl, ssh, GitHub access, where each repo will live
2. **base**: `pacman -Syu --needed git make base-devel openssh curl`
3. **repos**: clone or fast-forward `zsh`, `nvim`, `hyprland`, `sddm-login`
4. **zsh**: tools, link `~/.zshrc`, make zsh the login shell
   **tmux**: tools, link `~/.config/tmux`, plugins
5. **python**: `pacman -S --needed python uv`
6. **go**: `pacman -S --needed go` (before nvim: its language servers such as gopls are built with it)
7. **nvim**: tools, link `~/.config/nvim`, plugins at locked versions, language servers
8. **claude**: Claude Code via Anthropic's installer into `~/.local/bin/claude`; skipped if already installed.
   It updates itself; run `claude` in a project folder and log in in the browser the first time
9. **desktop**: Hyprland packages, Bluetooth and power-profile services, config links
10. **greeter**: greetd + the Quickshell login screen. It takes over from whatever display manager is active
   (archinstall's Hyprland profile installs SDDM) and records it, so `sudo make -C ~/projects/sddm-login revert`
   can undo it. To uninstall SDDM entirely afterwards: `sudo make -C ~/projects/sddm-login remove-sddm`.
