{ ... }:

let
  terminalVariant = import ./lib/tawny-variant.nix;
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = false;
    withRuby = false;
  };

  home.file = {
    ".config/nvim" = {
      source = ../config/nvim;
      recursive = true;
    };

    ".config/nvim/lua/config/tawny-generated.lua" = {
      force = true;
      text = ''
        return {
          variant = "${terminalVariant}",
        }
      '';
    };
  };
}
