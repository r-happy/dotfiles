{ pkgs, ... }:

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
        src = pkgs.fetchFromGitHub {
          owner = "yuys13";
          repo = "fish-ghq-fzf";
          rev = "main";
          hash = "sha256-64y5nTQsdz8Qyn0VjEtfI4FvTMjF5XVYW7yTsrkIS30=";
        };
      }
      {
        name = "fish-autols";
        src = pkgs.fetchFromGitHub {
          owner = "yuys13";
          repo = "fish-autols";
          rev = "main";
          hash = "sha256-5yb6UjPu+QFsR+fe1rzYgSUczQ6olbFgILUQNTGvnf8=";
        };
      }
    ];
    interactiveShellInit = ''
      fish_add_path ~/.nix-profile/bin
      fish_add_path /nix/var/nix/profiles/default/bin
      fish_add_path ~/.cargo/bin
      set -gx RUST_SRC_PATH ${pkgs.rustPlatform.rustLibSrc}

      ${builtins.readFile ../config/fish/config.fish}
    '';
  };
}
