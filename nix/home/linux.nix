{ ... }:

let
  settings = import ../lib/settings.nix;
in
{
  imports = [
    ./common.nix
    ../packages/linux.nix
    ../modules/desktop.nix
    ../modules/dms.nix
  ];

  home.homeDirectory = settings.homes.linux;
}
