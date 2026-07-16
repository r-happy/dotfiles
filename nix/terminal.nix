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
    fontSize = 11;
  };

  terminalTheme = terminalSettings // tawny.theme;

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

  mkWezTermConfig =
    theme:
    let
      palette = index: builtins.elemAt theme.palette index;
    in
    ''
      -- Managed by Home Manager. Colors sourced from tawny.nvim.
      local wezterm = require("wezterm")
      local config = wezterm.config_builder()

      config.colors = {
        foreground = "${theme.foreground}",
        background = "${theme.background}",
        cursor_bg = "${theme.cursorColor}",
        cursor_border = "${theme.cursorColor}",
        cursor_fg = "${theme.cursorText}",
        selection_bg = "${theme.selectionBackground}",
        selection_fg = "${theme.selectionForeground}",
        ansi = {
          "${palette 0}", "${palette 1}", "${palette 2}", "${palette 3}",
          "${palette 4}", "${palette 5}", "${palette 6}", "${palette 7}",
        },
        brights = {
          "${palette 8}", "${palette 9}", "${palette 10}", "${palette 11}",
          "${palette 12}", "${palette 13}", "${palette 14}", "${palette 15}",
        },
      }

      config.font = wezterm.font("${theme.fontFamily}")
      config.font_size = ${toString theme.fontSize}
      config.hide_tab_bar_if_only_one_tab = true
      config.enable_scroll_bar = false
      config.use_ime = true
      config.audible_bell = "Disabled"
      config.default_cursor_style = "SteadyBar"

      config.keys = {
        {
          key = "¥",
          mods = "CTRL",
          action = wezterm.action.SendKey { key = "\\", mods = "CTRL" },
        },
      }

      return config
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
    # font-thicken = true
    # font-thicken-strength = 60
    # background-opacity = 0.9
    # background-blur = true
    # macos-titlebar-style = tabs
  '';
in
{
  home.file = {
    ".config/kitty/kitty.conf" = {
      force = true;
      text = mkKittyConfig terminalTheme;
    };
    ".wezterm.lua" = {
      force = true;
      text = mkWezTermConfig terminalTheme;
    };
  }
  // lib.optionalAttrs pkgs.stdenv.isDarwin {
    "Library/Application Support/com.mitchellh.ghostty/config" = {
      force = true;
      text = mkGhosttyConfig terminalSettings;
    };
  };
}
