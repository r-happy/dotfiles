{ lib, pkgs, ... }:

let
  tawnyGhosttyThemePath = /Users/rhappy/github/tawny.nvim/ghostty/color.ghostty;

  tawnyThemeLines = lib.splitString "\n" (builtins.readFile tawnyGhosttyThemePath);

  getThemeValue =
    pattern:
    let
      matches = lib.filter (match: match != null) (map (line: builtins.match pattern line) tawnyThemeLines);
    in
    builtins.elemAt (builtins.head matches) 0;

  paletteAttrs =
    builtins.listToAttrs (
      map (match: {
        name = builtins.elemAt match 0;
        value = builtins.elemAt match 1;
      }) (
        lib.filter (match: match != null) (
          map (line: builtins.match "^palette = ([0-9]+)=(#[0-9a-fA-F]+)$" line) tawnyThemeLines
        )
      )
    );

  terminalTheme = {
    fontFamily = "UDEV Gothic 35NFLG";
    fontSize = 11;

    background = getThemeValue "^background = (#[0-9a-fA-F]+)$";
    foreground = getThemeValue "^foreground = (#[0-9a-fA-F]+)$";
    selectionBackground = getThemeValue "^selection-background = (#[0-9a-fA-F]+)$";
    selectionForeground = getThemeValue "^selection-foreground = (#[0-9a-fA-F]+)$";
    cursorColor = getThemeValue "^cursor-color = (#[0-9a-fA-F]+)$";
    cursorText = getThemeValue "^cursor-text = (#[0-9a-fA-F]+)$";

    palette = map (index: paletteAttrs.${toString index}) (lib.range 0 15);
  };

  mkKittyConfig =
    theme:
    let
      paletteLines = lib.concatImapStringsSep "\n" (index: color: "color${toString index} ${color}") theme.palette;
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
      enable_audio_bell no
      visual_bell_duration 0.0
    '';

  mkGhosttyConfig =
    theme:
    let
      paletteLines =
        lib.concatImapStringsSep "\n" (index: color: "palette = ${toString index}=${color}") theme.palette;
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
  home.file =
    {
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
