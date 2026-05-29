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
      selectionBackground = colors."editor.selectionBackground";
      selectionForeground = colors."terminal.foreground";
      cursorColor = colors."terminalCursor.foreground";
      cursorText = colors."terminal.background";
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
