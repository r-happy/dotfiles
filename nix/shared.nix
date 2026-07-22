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
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
  };
  programs.home-manager.enable = true;
}
