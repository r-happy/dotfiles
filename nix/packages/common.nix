{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    fd

    ghq
    fzf
    eza

    openssh
  ];
}
