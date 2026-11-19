# archminimal-setup — run `make help`. Every target calls bin/setup; add
# DRY_RUN=1 to see the commands without running them.

SETUP := ./bin/setup $(if $(DRY_RUN),--dry-run) $(if $(YES),--yes)
.DEFAULT_GOAL := help
.PHONY: help all tmux doctor base git packages packages-check packages-clean repos zsh python go nvim claude desktop greeter status update check ssh-key migrate snapshot remove-sddm

help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ {printf "  \033[36m%-8s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

all: ## Everything: doctor, btrfs snapshot, base, git, repos, zsh, tmux, python, go, nvim, claude, desktop, login screen, remove SDDM
	@$(SETUP) all
doctor: ## Check system, tools and GitHub access; show the plan
	@$(SETUP) doctor
base: ## Base packages (git, make, base-devel, openssh)
	@$(SETUP) base
git: ## Git name/email in ~/.gitconfig (GIT_NAME=, GIT_EMAIL= or asks); ssh-agent: passphrase once per login
	@GIT_NAME="$(GIT_NAME)" GIT_EMAIL="$(GIT_EMAIL)" $(SETUP) git
packages: ## macOS: install everything in the Brewfile
	@$(SETUP) packages
packages-check: ## macOS: list packages installed but not in the Brewfile
	@$(SETUP) packages-check
packages-clean: ## macOS: uninstall packages not in the Brewfile (asks first)
	@$(SETUP) packages-clean
repos: ## Clone missing repos into /opt/archminimal (created once, sudo), fast-forward the rest
	@$(SETUP) repos
zsh: ## Shell: tools, ~/.zshrc link, login shell
	@$(SETUP) zsh
tmux: ## tmux: tools, ~/.config/tmux link, plugins
	@$(SETUP) tmux
python: ## Python + uv (projects, venvs, CLI tools)
	@$(SETUP) python
go: ## Go toolchain (GOPATH ~/go, ~/go/bin on PATH)
	@$(SETUP) go
nvim: ## Editor: tools, ~/.config/nvim link, plugins, language servers
	@$(SETUP) nvim
claude: ## Claude Code CLI (official installer, updates itself)
	@$(SETUP) claude
desktop: ## Hyprland desktop: bar, launcher, lock, kitty (Arch)
	@$(SETUP) desktop
greeter: ## Login screen only: greetd + Quickshell, replaces SDDM/any display manager (Arch)
	@$(SETUP) greeter
status: ## Branch, local changes and links for every repo; tool versions
	@$(SETUP) status
update: ## Pull every repo and update plugins
	@$(SETUP) update
check: ## Run each repo's own checks
	@$(SETUP) check
ssh-key: ## Create an SSH key and show how to add it to GitHub
	@$(SETUP) ssh-key
snapshot: ## Read-only btrfs snapshot of / without /home (LABEL=name to tag it)
	@$(SETUP) snapshot $(LABEL)
remove-sddm: ## Snapshot /, then wipe SDDM: packages, config, state, user (Arch)
	@$(SETUP) remove-sddm
migrate: ## Move clones from ~/projects and downloaded plugins out of home, relink everything
	@$(SETUP) migrate
