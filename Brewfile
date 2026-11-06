# Everything this Mac should have installed with Homebrew, and why.
#
#   make packages        install whatever is missing (brew bundle)
#   make packages-check  list what is installed but NOT in this file
#   make packages-clean  uninstall those (asks first)
#
# Add a package here instead of a bare `brew install`, with a comment saying
# what needs it: then nothing ends up installed for an unknown reason.
# Arch gets the same tools from each repo's own installer (pacman).

# ---------- shell (zsh repo) ----------
brew "zsh"
brew "git"
brew "git-delta"     # diffs in git and lazygit
brew "lazygit"
brew "fzf"
brew "zoxide"
brew "eza"
brew "fd"
brew "ripgrep"
brew "bat"
brew "btop"
brew "htop"
brew "tldr"
brew "fastfetch"
brew "tmux"
brew "direnv"        # per-project .envrc (layout project)
brew "atuin"         # shell history search / sync

# ---------- secrets ----------
brew "gitleaks"      # global pre-commit hook: blocks committed secrets
brew "sops"          # encrypted .env.sops files
brew "age"           # the key sops encrypts with

# ---------- editor (nvim repo) ----------
brew "neovim"
brew "tree-sitter-cli"   # builds treesitter parsers
brew "node"              # mason's language servers (pyright, bash, typescript)
brew "stylua"            # Lua formatter
brew "pgformatter"       # SQL formatter (pg_format)
brew "imagemagick"       # image.nvim: plots and images in notebooks
brew "make"

# ---------- languages ----------
brew "go"
brew "python@3.13"
brew "uv"            # Python projects, venvs and CLI tools (jupytext, black)

# ---------- containers / kubernetes (personal-ai) ----------
brew "docker"
brew "kubernetes-cli"
brew "minikube"
brew "libpq"         # psql, and building psycopg

# ---------- network ----------
brew "gh"
brew "openconnect"   # Cisco AnyConnect VPN
brew "autossh"       # tunnels that reconnect
brew "telnet"
