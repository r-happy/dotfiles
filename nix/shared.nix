{ ... }:

let
  settings = import ./lib/settings.nix;
in
{
  imports = [
    ./packages/shared.nix
    ./lsp.nix
    ./shell.nix
    ./git.nix
    ./editor.nix
    ./terminal.nix
    ./tmux.nix
  ];

  home.username = settings.username;
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
