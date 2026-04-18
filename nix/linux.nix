{ ... }:

{
  imports = [
    ./shared.nix
    ./packages/linux.nix
  ];

  home.homeDirectory = "/home/rhappy";
}
