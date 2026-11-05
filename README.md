# linux_setup

One command to set up the whole archminimal environment on a fresh Arch Linux machine (and the shell and
editor parts on macOS). It clones the component repos and runs each one's own installer in the right order.

| Repo | What it sets up | Arch | macOS |
|---|---|---|---|
| [`zsh`](https://github.com/NobodyOne04/zsh) | fast zsh with p10k prompt, fzf, devops helpers | ✓ | ✓ |
| [`nvim`](https://github.com/NobodyOne04/nvim) | Neovim: LSP, treesitter, telescope, completion, Copilot | ✓ | ✓ |
| [`hyprland`](https://github.com/NobodyOne04/hyprland) | Hyprland desktop: bar, launcher, lock, idle, Ghostty | ✓ | |
| [`sddm-login`](https://github.com/NobodyOne04/sddm-login) | login screen: greetd + Quickshell greeter (no SDDM) | ✓ | |

## Fresh Arch install

From a TTY on a freshly installed Arch (with a user that has sudo):

```bash
sudo pacman -S --needed git make openssh
# the repos are private: give this machine a GitHub SSH key
ssh-keygen -t ed25519 && cat ~/.ssh/id_ed25519.pub   # add it at https://github.com/settings/ssh/new

git clone git@github.com:NobodyOne04/linux_setup.git ~/projects/linux_setup
cd ~/projects/linux_setup
make doctor     # checks tools and GitHub access, shows the plan
make all        # base packages, repos, zsh, nvim, desktop, login screen
reboot          # the archminimal login screen starts Hyprland
```

`make all` asks for your sudo password and confirms each pacman install. Add `DRY_RUN=1` to any target to see
every command without running it, e.g. `make all DRY_RUN=1`.

## Everyday

| Command | What |
|---|---|
| `make status` | each repo's branch, unpushed or uncommitted work, and whether its links are in place |
| `make update` | pull every repo (fast-forward only; repos with local changes are left alone), update plugins |
| `make check` | run each repo's own checks (zsh startup, nvim startup, Hyprland and greeter lint) |
| `make zsh` / `nvim` / `desktop` | (re)install one part |
| `make ssh-key` | create a key if missing and show where to add it |

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
5. **nvim**: tools, link `~/.config/nvim`, plugins at locked versions, language servers
6. **desktop**: Hyprland packages, Bluetooth and power-profile services, config links
7. **greeter**: greetd + the Quickshell login screen. It takes over from whatever display manager is active
   (archinstall's Hyprland profile installs SDDM) and records it, so `sudo make -C ~/projects/sddm-login revert`
   can undo it. To uninstall SDDM entirely afterwards: `sudo make -C ~/projects/sddm-login remove-sddm`.
