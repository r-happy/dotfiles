{ ... }:

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
  };
}
