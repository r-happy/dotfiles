{ ... }:

let
  settings = import ../lib/settings.nix;
in
{
  imports = [
    ./common.nix
    ../packages/linux.nix
    ../modules/desktop.nix
  ];

  home.homeDirectory = settings.homes.linux;
}
