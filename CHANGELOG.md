# Changelog

## Unreleased

### Fixed
- Fresh install (Codex audit): `make all` no longer stops at the snapshot when `btrfs-progs` is missing; base installs CPU microcode and Intel GPU and audio firmware; SDDM is removed only from a desktop the new login screen started; a checkout of another repo (host, owner and name checked) is refused; a failed pull stops the run; rollback steps are right for a top-level `/` and a `/home` folder; `make check` fails when a repo is missing
- Security: a repo is found by owner and name in its origin, not name alone, and a step that runs `sudo make` refuses a repo or `$PROJECTS` folder not owned by you (Codex audit)

### Added
- Plugins live in `/opt/archminimal/plugins`, outside home; `make migrate` moves the ones already downloaded
- `make git` (also in `make all`, after base): git name/email in `~/.gitconfig`; on Linux the ssh-agent socket
  and `~/.ssh/config` lines so a key's passphrase is asked once per login
- `make snapshot`: read-only btrfs snapshot of `/` without `/home`, beside the root subvolume in `snapshots/`
- `make remove-sddm`: snapshots `/`, then removes SDDM completely: packages and their cached downloads,
  config, state, logs, the `sddm` user and group, `~/.local/share/sddm`
- `make all` takes a btrfs snapshot of `/` first (when `/` is btrfs) and ends with `remove-sddm`
- Repos live in `/opt/archminimal`, outside home, so home can be wiped and relinked; `make migrate` moves an existing `~/projects` setup
- Decision records in `docs/adr/`: six ADRs for the repo's existing decisions

### Changed
- Desktop step asks to install the camera kill switch (`make privacy`); `make update` warns when it is out of date
- Renamed `linux_setup` → `archminimal-setup`, and the desktop repo `hyprland` → `archminimal-hypr` (both renamed
  on GitHub: history kept, old URLs redirect). `setup repos` finds an old `hyprland` clone and points its origin
  at `archminimal-hypr`; the folder name doesn't matter
- The login screen repo is `archminimal-greeter` (was `sddm-login`, now deleted): `setup repos` clones it,
  `greeter`, `status` and `check` use it. On a machine that still has `~/projects/sddm-login`, run `setup repos`
  to clone the new one; the old folder can then be removed (installed files have the same names)
