{ lib, tawnyNvim }:

let
  mkThemeFromVscode =
    path:
    let
      colors = (builtins.fromJSON (builtins.readFile path)).colors;
    in
    {
      background = colors."terminal.background";
      foreground = colors."terminal.foreground";
      accent = colors."focusBorder";
      selectionBackground = colors."editor.selectionBackground";
      selectionForeground = colors."terminal.foreground";
      cursorColor = colors."terminalCursor.foreground";
      cursorText = colors."terminal.background";
      titlebarBackground = colors."titleBar.activeBackground";
      titlebarForeground = colors."titleBar.activeForeground";
      tabActiveBackground = colors."tab.activeBackground";
      tabActiveForeground = colors."tab.activeForeground";
      tabInactiveBackground = colors."tab.inactiveBackground";
      tabInactiveForeground = colors."tab.inactiveForeground";

      # Material-style surface ramp and semantic colors, for shells that expect
      # one (DMS, see nix/modules/dms.nix). Plain renames of tawny's own keys so
      # the shell can't drift from the editor and the terminal.
      accentText = colors."button.foreground";
      accentContainer = colors."button.secondaryBackground";
      secondary = colors."terminal.ansiYellow";
      surfaceContainer = colors."sideBar.background";
      surfaceContainerHigh = colors."editorWidget.background";
      surfaceContainerHighest = colors."tab.hoverBackground";
      surfaceVariant = colors."widget.border";
      surfaceVariantText = colors."descriptionForeground";
      outline = colors."disabledForeground";
      outlineVariant = colors."widget.border";
      error = colors."editorError.foreground";
      warning = colors."editorWarning.foreground";
      info = colors."editorInfo.foreground";
      success = colors."gitDecoration.addedResourceForeground";
      palette = [
        colors."terminal.ansiBlack"
        colors."terminal.ansiRed"
        colors."terminal.ansiGreen"
        colors."terminal.ansiYellow"
        colors."terminal.ansiBlue"
        colors."terminal.ansiMagenta"
        colors."terminal.ansiCyan"
        colors."terminal.ansiWhite"
        colors."terminal.ansiBrightBlack"
        colors."terminal.ansiBrightRed"
        colors."terminal.ansiBrightGreen"
        colors."terminal.ansiBrightYellow"
        colors."terminal.ansiBrightBlue"
        colors."terminal.ansiBrightMagenta"
        colors."terminal.ansiBrightCyan"
        colors."terminal.ansiBrightWhite"
      ];
    };
in
{
  dark = mkThemeFromVscode "${tawnyNvim}/vscode/themes/tawny-dark-color-theme.json";
  light = mkThemeFromVscode "${tawnyNvim}/vscode/themes/tawny-light-color-theme.json";
}
