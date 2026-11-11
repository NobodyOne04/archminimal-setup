# archminimal-setup

Formerly `linux_setup` (renamed on GitHub; old URLs redirect).

One command to set up the archminimal environment: clones the component repos (`zsh`, `tmux`, `nvim`,
`archminimal-hypr`, `archminimal-greeter`) into `~/projects` and runs each one's own installer in order. Arch for
everything, macOS for the shell and editor parts. What each step does: `README.md`.

## Commands
- `make <step>` calls `bin/setup <step>`; `DRY_RUN=1 make <step>` (or `bin/setup --dry-run <step>`) prints the
  commands without running them. Safe on macOS: `DRY_RUN=1 make doctor`, `make status`.
- `make check` runs every cloned repo's own check/lint. `bash -n bin/setup` for syntax.

## Layout
- `bin/setup`: all logic. `REPOS=(…)` is the repo list; `repo_dir` finds a clone anywhere in `$PROJECTS` by
  its origin URL (or a pre-rename name from `old_name`, which `setup repos` then re-points); one `cmd_<step>` function per step.
- `Makefile`: thin wrappers with help text. `Brewfile`: macOS packages.
- `docs/adr/`: decision records (`NNNN-*.adr`, index `README.md`); read the one for a decision before changing it.

## Conventions
- This script runs `sudo`, `pacman`, `systemctl` and changes the login manager on a fresh machine: every
  command goes through `run` (so `--dry-run` shows it) and anything destructive through `confirm`.
- Each component repo owns its install logic; this repo only orders and calls it. A renamed or new component
  repo means updating `REPOS`, its `cmd_*`, `cmd_status`, `cmd_check` and the README table together; a
  GitHub rename (history kept) also gets an `old_name` entry. A copy into a fresh repo (like
  `sddm-login` → `archminimal-greeter`) must not: its history is unrelated, so pulling would fail.
- Public repo: no machine names, keys or personal paths beyond `~/projects`.
- Changes go through `github-flow` (squash only).
