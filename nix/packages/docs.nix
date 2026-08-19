{ pkgs, ... }:

{
  home.packages = with pkgs; [
    presenterm
    texliveFull
    poppler-utils
    tesseract
    texlab
    texlivePackages.latexindent
  ];
}
