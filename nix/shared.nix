{ ... }:

{
  imports = [
    ./packages/shared.nix
    ./lsp.nix
    ./shell.nix
    ./git.nix
    ./editor.nix
    ./tmux.nix
  ];

  home.username = "rhappy";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
