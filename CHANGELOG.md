# Changelog

## Unreleased

### Added
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
