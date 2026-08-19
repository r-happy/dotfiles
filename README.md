# dotfiles

`make switch` applies the configuration for the current platform. It never
updates inputs; `make update` is the explicit lockfile-update step.

Optional package groups are selected in `nix/profiles.nix`. `development` is
enabled by default; `docs` (TeX Live/PDF/OCR) and `ctf` are opt-in so a normal
switch does not pull their large closures.
