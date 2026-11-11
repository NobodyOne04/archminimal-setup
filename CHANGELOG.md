# Changelog

## Unreleased

### Changed
- Renamed `linux_setup` → `archminimal-setup`, and the desktop repo `hyprland` → `archminimal-hypr` (both renamed
  on GitHub: history kept, old URLs redirect). `setup repos` finds an old `hyprland` clone and points its origin
  at `archminimal-hypr`; the folder name doesn't matter
- The login screen repo is `archminimal-greeter` (was `sddm-login`, now deleted): `setup repos` clones it,
  `greeter`, `status` and `check` use it. On a machine that still has `~/projects/sddm-login`, run `setup repos`
  to clone the new one; the old folder can then be removed (installed files have the same names)
