{ pkgs, inputs, ... }:

let
  settings = import ../lib/settings.nix;
in
{
  programs.fish.enable = true;

  imports = [
    ./macos-defaults.nix
    inputs.home-manager.darwinModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.${settings.username} = import ../home/darwin.nix;
  };

  environment.shells = with pkgs; [ fish ];

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  system.primaryUser = settings.username;

  users.users.${settings.username} = {
    home = settings.homes.darwin;
    shell = pkgs.fish;
  };

  system.stateVersion = 6;
}
