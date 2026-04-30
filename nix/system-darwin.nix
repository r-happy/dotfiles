{ pkgs, ... }:

{
  programs.fish.enable = true;

  imports = [
    ./macos-defaults.nix
  ];

  environment.shells = with pkgs; [ fish ];

  system.primaryUser = "rhappy";

  users.users.rhappy = {
    home = "/Users/rhappy";
    shell = pkgs.fish;
  };

  system.stateVersion = 6;
}
