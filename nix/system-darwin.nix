{ pkgs, ... }:

{
  programs.fish.enable = true;

  imports = [
    ./macos-defaults.nix
  ];

  environment.shells = with pkgs; [ fish ];

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  system.primaryUser = "rhappy";

  users.users.rhappy = {
    home = "/Users/rhappy";
    shell = pkgs.fish;
  };

  system.stateVersion = 6;
}
