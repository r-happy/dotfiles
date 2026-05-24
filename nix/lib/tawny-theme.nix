{ lib, tawnyNvim }:

let
  tawnyGhosttyThemePath = "${tawnyNvim}/ghostty/color.ghostty";

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
in
{
  background = getThemeValue "^background = (#[0-9a-fA-F]+)$";
  foreground = getThemeValue "^foreground = (#[0-9a-fA-F]+)$";
  selectionBackground = getThemeValue "^selection-background = (#[0-9a-fA-F]+)$";
  selectionForeground = getThemeValue "^selection-foreground = (#[0-9a-fA-F]+)$";
  cursorColor = getThemeValue "^cursor-color = (#[0-9a-fA-F]+)$";
  cursorText = getThemeValue "^cursor-text = (#[0-9a-fA-F]+)$";
  palette = map (index: paletteAttrs.${toString index}) (lib.range 0 15);
}
