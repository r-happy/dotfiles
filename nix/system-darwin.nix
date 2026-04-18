{ pkgs, ... }:

{
  programs.fish.enable = true;

  environment.shells = with pkgs; [ fish ];

  users.users.rhappy = {
    home = "/Users/rhappy";
    shell = pkgs.fish;
  };

  system.stateVersion = 6;
}
