# Changelog

## Unreleased

### Changed
- The login screen repo is `archminimal-greeter` (was `sddm-login`, now deleted): `setup repos` clones it,
  `greeter`, `status` and `check` use it. On a machine that still has `~/projects/sddm-login`, run `setup repos`
  to clone the new one; the old folder can then be removed (installed files have the same names)
