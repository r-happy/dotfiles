{ ... }:

let
  settings = import ../lib/settings.nix;
in
{
  imports = [
    ../packages/common.nix
    ../modules/shell.nix
    ../modules/git.nix
    ../modules/editor.nix
    ../modules/terminal.nix
    ../modules/tmux.nix
  ];

  home.username = settings.username;
  home.stateVersion = "23.11";
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
  };
  programs.home-manager.enable = true;
}
