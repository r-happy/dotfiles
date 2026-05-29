{
  lib,
  pkgs,
  tawnyNvim,
  ...
}:

let
  terminalVariant = import ./lib/tawny-variant.nix;

  tawnyThemes = import ./lib/tawny-theme.nix {
    inherit lib tawnyNvim;
  };

  terminalTheme = {
    # fontFamily = "Moralerspace Neon";
    # fontFamily = "PlemolJP35 Console NF";
    fontFamily = "UDEV Gothic 35NFLG";
    fontSize = 11;
  }
  // tawnyThemes.${terminalVariant};

  mkKittyConfig =
    theme:
    let
      paletteIndices = lib.range 0 ((builtins.length theme.palette) - 1);
      paletteLines = lib.concatMapStringsSep "\n" (
        index: "color${toString index} ${builtins.elemAt theme.palette index}"
      ) paletteIndices;
      macosLines = lib.optionalString pkgs.stdenv.isDarwin ''
        macos_titlebar_color background
      '';
    in
    ''
      # Managed by Home Manager. Colors sourced from tawny.nvim.
      font_family ${theme.fontFamily}
      font_size ${toString theme.fontSize}

      background ${theme.background}
      foreground ${theme.foreground}
      selection_background ${theme.selectionBackground}
      selection_foreground ${theme.selectionForeground}

      cursor ${theme.cursorColor}
      cursor_text_color ${theme.cursorText}

      ${paletteLines}

      macos_option_as_alt yes
      ${macosLines}
      enable_audio_bell no
      visual_bell_duration 0.0
    '';

  mkGhosttyConfig =
    theme:
    let
      paletteIndices = lib.range 0 ((builtins.length theme.palette) - 1);
      paletteLines = lib.concatMapStringsSep "\n" (
        index: "palette = ${toString index}=${builtins.elemAt theme.palette index}"
      ) paletteIndices;
    in
    ''
      # Managed by Home Manager. Colors sourced from tawny.nvim.
      font-family = ${theme.fontFamily}
      font-size = ${toString theme.fontSize}

      background = ${theme.background}
      foreground = ${theme.foreground}
      selection-background = ${theme.selectionBackground}
      selection-foreground = ${theme.selectionForeground}

      cursor-color = ${theme.cursorColor}
      cursor-text = ${theme.cursorText}

      ${paletteLines}

      macos-option-as-alt = true

      window-decoration = auto
      scrollbar = never
      bell-features = no-system
      macos-titlebar-proxy-icon = hidden
    '';
in
{
  home.file = {
    ".config/kitty/kitty.conf" = {
      force = true;
      text = mkKittyConfig terminalTheme;
    };
  }
  // lib.optionalAttrs pkgs.stdenv.isDarwin {
    "Library/Application Support/com.mitchellh.ghostty/config.ghostty" = {
      force = true;
      text = mkGhosttyConfig terminalTheme;
    };
  };
}
