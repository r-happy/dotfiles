{
  lib,
  pkgs,
  tawnyNvim,
  ...
}:

let
  tawnyTheme = import ./lib/tawny-theme.nix {
    inherit lib tawnyNvim;
  };

  terminalTheme = {
    # fontFamily = "Moralerspace Neon";
    fontFamily = "PlemolJP35 Conosole NF";
    # fontFamily = "UDEV Gothic NFLG";
    fontSize = 11;
  }
  // tawnyTheme;

  mkKittyConfig =
    theme:
    let
      paletteLines = lib.concatImapStringsSep "\n" (
        index: color: "color${toString index} ${color}"
      ) theme.palette;
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
      paletteLines = lib.concatImapStringsSep "\n" (
        index: color: "palette = ${toString index}=${color}"
      ) theme.palette;
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
