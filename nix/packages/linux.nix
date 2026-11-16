{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wl-clipboard
    claude-code
  ];
}
