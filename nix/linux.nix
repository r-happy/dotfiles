{ ... }:

let
  settings = import ./lib/settings.nix;
in
{
  imports = [
    ./shared.nix
    ./packages/linux.nix
  ];

  home.homeDirectory = settings.homes.linux;
}
