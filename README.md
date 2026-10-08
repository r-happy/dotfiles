# dotfiles

`make switch` applies the configuration for the current platform. It never
updates inputs; `make update` is the explicit lockfile-update step.

This repository manages the personal environment: macOS/Linux settings, Fish,
Git/SSH, Neovim, terminal themes, tmux, and direnv. Fish keeps its existing plugins and
PATH initialization. Shared command-line packages are limited to ripgrep, fd,
ghq, fzf, eza, and Codex CLI, plus platform clipboard integration.
Language toolchains, LSP servers, formatters, Docker clients, document tools, and
CTF tools belong in each project's `flake.nix`.

Fish settings live in `nix/modules/shell.nix`; the `memo` function body lives in
`config/fish/functions/memo.fish`. Platform switch commands live in `nix/switch.nix`.
Fish plugins update through `make update`; the two custom plugins are flake inputs.
Repository paths are defined in `nix/lib/settings.nix`, including the default
Neovim checkout and memo directory. Terminal and tmux colors share the same
theme data from tawny.nvim. Git's global ignore excludes macOS metadata such as
`.DS_Store` and AppleDouble files.

Codex CLI comes from [llm-agents.nix](https://github.com/numtide/llm-agents.nix),
which updates packages daily, independently of the stable nixpkgs input.
It keeps its own tested nixpkgs input; the Numtide binary cache is configured
in `nixConfig` to avoid compiling Codex locally. Accept that flake configuration
when Nix prompts for it.
Run `make switch` to install it on macOS or Linux, then `codex` to sign in.
To update the environment, including Codex, and apply it:

```sh
make update
make switch
codex --version
```

Codex updates depend on llm-agents.nix publishing the new version; they do not
happen automatically when launching Codex.

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
