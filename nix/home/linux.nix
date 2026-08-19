{ ... }:

let
  settings = import ../lib/settings.nix;
in
{
  imports = [
    ./common.nix
    ../packages/linux.nix
  ];

  home.homeDirectory = settings.homes.linux;
}
