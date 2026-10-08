{ pkgs, inputs, ... }:

let
  settings = import ../lib/settings.nix;
in
{
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "pure";
        src = pkgs.fishPlugins.pure.src;
      }
      {
        name = "fish-ghq-fzf";
        src = inputs.fish-ghq-fzf;
      }
      {
        name = "fish-autols";
        src = inputs.fish-autols;
      }
    ];
    functions.memo = ''
      set -l BASE_DIR "$HOME/${settings.paths.memo}"
    '' + builtins.readFile ../../config/fish/functions/memo.fish;

    interactiveShellInit = ''
      fish_add_path ~/.nix-profile/bin
      fish_add_path /nix/var/nix/profiles/default/bin
      fish_add_path ~/.cargo/bin
    '';
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };
}
