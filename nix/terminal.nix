{
  lib,
  pkgs,
  tawnyNvim,
  ...
}:

let
  tawny = import ./lib/tawny.nix {
    inherit lib tawnyNvim;
  };

  terminalSettings = {
    # fontFamily = "Moralerspace Neon";
    fontFamily = "PlemolJP35 Console NF";
    # fontFamily = "UDEV Gothic 35NFLG";
    fontSize = 12;
  };

  kittyTheme = terminalSettings // tawny.theme;

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

  mkGhosttyConfig = settings: ''
    # Managed by Home Manager. Colors sourced from tawny.nvim.
    ${builtins.readFile "${tawnyNvim}/ghostty/color.ghostty"}

    font-family = ${settings.fontFamily}
    font-size = ${toString settings.fontSize}

    macos-option-as-alt = true
    window-decoration = auto
    scrollbar = never
    bell-features = no-system
    macos-titlebar-proxy-icon = hidden
    keybind = ¥=text:\\
    font-thicken = true
    font-thicken-strength = 60
    # background-opacity = 0.9
    # background-blur = true
    # macos-titlebar-style = tabs
  '';
in
{
  home.file = {
    ".config/kitty/kitty.conf" = {
      force = true;
      text = mkKittyConfig kittyTheme;
    };
  }
  // lib.optionalAttrs pkgs.stdenv.isDarwin {
    "Library/Application Support/com.mitchellh.ghostty/config" = {
      force = true;
      text = mkGhosttyConfig terminalSettings;
    };
  };
}
