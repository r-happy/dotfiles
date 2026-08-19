{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fastfetch
    ripgrep
    fd
    bat
    chafa

    ghq
    fzf
    eza

    openssh
    wget
  ];
}
