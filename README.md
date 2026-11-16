# dotfiles

`make switch` applies the configuration for the current platform. It never
updates inputs; `make update` is the explicit lockfile-update step.

On NixOS, `make switch` runs `nixos-rebuild` for `nixosConfigurations.nixos`
(niri, fcitx5-mozc, fonts, and this Home Manager setup). The host lives in
`nix/hosts/nixos/`; `hardware-configuration.nix` there is copied from
`/etc/nixos/` on the machine. The first run needs
`NIX_CONFIG="experimental-features = nix-command flakes" make switch`.
The niri config is `config/niri/config.kdl` (colors are filled in from
tawny.nvim); input, keybind helpers and GTK live in `nix/modules/desktop.nix`.
The bar, launcher and notifications come from DMS (Dank Material Shell), whose
settings, tawny theme and wallpapers are pinned in `nix/modules/dms.nix` — DMS
sees those files read-only, so its settings window offers copy buttons to paste
changes back into Nix. The wallpapers are the whole of `assets/wallpapers/`,
cycled in filename order every 30 minutes (`dms ipc call wallpaper next` steps
by hand); each session starts from the first one again.

This repository manages the personal environment: macOS/Linux settings, Fish,
Git/SSH, Neovim, Emacs, terminal themes, tmux, and direnv. Fish keeps its existing plugins and
PATH initialization. Shared command-line packages are limited to ripgrep, fd,
ghq, fzf, and eza, plus platform clipboard integration.
Language toolchains, LSP servers, formatters, document tools, and CTF tools
belong in each project's `flake.nix`. The Docker engine is the exception: a
daemon cannot live in a project flake, so `nix/system/nixos.nix` enables
`virtualisation.docker` (with the login user in the `docker` group). That is
NixOS-only — on macOS an engine would mean a VM, so nothing is installed there.

Fish settings live in `nix/modules/shell.nix`; the `memo` function body lives in
`config/fish/functions/memo.fish`. Platform switch commands live in `nix/switch.nix`.
Fish plugins update through `make update`; the two custom plugins are flake inputs.
Repository paths are defined in `nix/lib/settings.nix`, including the default
Neovim checkout and memo directory. Terminal and tmux colors share the same
theme data from tawny.nvim. Ghostty is the default terminal:
`nix/modules/terminal.nix` writes its config on both platforms, and on NixOS
Mod+T and `$TERMINAL` point at it (kitty and WezTerm keep their themed configs
as alternatives). Git's global ignore excludes macOS metadata such as
`.DS_Store` and AppleDouble files.

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
