{ ... }:

{
  imports = [
    ./shared.nix
    ./packages/darwin.nix
  ];

  home.homeDirectory = "/Users/rhappy";
}
