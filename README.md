# dotfiles

`make switch` applies the configuration for the current platform. It never
updates inputs; `make update` is the explicit lockfile-update step.

This repository manages the personal environment: macOS/Linux settings, Fish,
Git/SSH, Neovim, terminal themes, tmux, and direnv. Fish keeps its existing plugins and
PATH initialization. Shared command-line packages are limited to ripgrep, fd,
ghq, fzf, and eza, plus platform clipboard integration.
Language toolchains, LSP servers, formatters, Docker clients, document tools, and
CTF tools belong in each project's `flake.nix`.

`make switch` sources Neovim from the local companion checkout at
`~/github/nixvim-config` on both macOS and Linux. Clone it there first, or pass
`NIXVIM_CONFIG=/absolute/path/to/nixvim-config` to make. This overrides the
GitHub input without updating the lockfile. Direct flake commands use the
locked GitHub version unless given the same `--override-input` option.
Publishing dotfiles alone does not publish changes to that separate repository;
the minimal editor changes must also be committed and published there before
the GitHub input can provide them.

For a project with a dev shell, run `nix develop -c fish`, then launch `nvim`.
Direnv is installed with Fish integration and nix-direnv enabled. For a project
with an `.envrc` containing `use flake`, review it and run `direnv allow` once.
Start a new editor inside the environment when switching projects so its
language servers inherit the right tools.

The first migrated project is `~/github/2026-taikusai`. Other projects need their
own dev shells before relying on language tooling removed from this repository.
`make switch` applies these removals to the installed environment; editing these
files alone does not uninstall the currently active tools.
