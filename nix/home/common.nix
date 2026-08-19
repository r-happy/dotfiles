{ lib, ... }:

let
  settings = import ../lib/settings.nix;
  profiles = import ../profiles.nix;
in
{
  imports = [
    ../packages/common.nix
    ../modules/lsp.nix
    ../modules/shell.nix
    ../modules/git.nix
    ../modules/editor.nix
    ../modules/terminal.nix
    ../modules/tmux.nix
  ]
  ++ lib.optionals profiles.development [ ../packages/development.nix ]
  ++ lib.optionals profiles.docs [ ../packages/docs.nix ]
  ++ lib.optionals profiles.ctf [ ../packages/ctf.nix ];

  home.username = settings.username;
  home.stateVersion = "23.11";
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
  };
  programs.home-manager.enable = true;
}
