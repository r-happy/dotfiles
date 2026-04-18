{ pkgs, ... }:

{
  imports = [
    ./shared.nix
    ./packages/darwin.nix
  ];
}
