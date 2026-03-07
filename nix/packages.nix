{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fastfetch
    ripgrep
    fd
    bat
    chafa

    rustc
    cargo
    rustfmt
    clippy

    go
    nodejs
    bun
    pnpm
    python3
    opencode

    clang
    unzip
    gnumake

    tree-sitter
    luarocks
    claude-code

    wl-clipboard

    ghq
    fzf

    docker
    docker-compose
  ];
}
