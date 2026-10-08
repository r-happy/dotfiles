{ ... }:

let
  settings = import ../lib/settings.nix;
in
{
  programs.git = {
    enable = true;
    ignores = [
      ".DS_Store"
      "._*"
      ".AppleDouble"
      ".LSOverride"
    ];
    settings = {
      user = {
        name = settings.git.name;
        email = settings.git.email;
      };
      ghq = {
        root = settings.git.root;
      };
    };
    signing.format = null;
  };

  programs.gh.enable = true;
  programs.lazygit.enable = true;
}
