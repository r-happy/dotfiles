{
  pkgs,
  inputs,
  ...
}:

{
  home.packages = [
    pkgs.emacs
    inputs.nixvim-config.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
  };
}
