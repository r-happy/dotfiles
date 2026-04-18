{ ... }:

{
  imports = [
    ./packages/shared.nix
    ./shell.nix
    ./git.nix
    ./editor.nix
    ./tmux.nix
  ];

  home.username = "rhappy";
  home.stateVersion = "23.11";
  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
}
