{
  lib,
  tawnyNvim,
}:

let
  terminalVariant = import ./tawny-variant.nix;
  tawnyThemes = import ./tawny-theme.nix {
    inherit lib tawnyNvim;
  };
in
{
  inherit terminalVariant tawnyThemes;
  theme = tawnyThemes.${terminalVariant};
}
