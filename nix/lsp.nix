{ pkgs, ... }:

{
  home.sessionVariables = {
    RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
  };

  home.packages = with pkgs; [
    rust-analyzer
    rustPlatform.rustLibSrc
    gopls
    typescript
    typescript-language-server
    lua-language-server
    basedpyright
    ruff
    nil
    sqls
    texlab
    vscode-langservers-extracted
    prettier
    sql-formatter
    texlivePackages.latexindent
  ];
}
