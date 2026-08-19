{
  pkgs,
  codex-cli-nix,
  ...
}:

let
  codexCli = codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default;

  gpp = pkgs.writeShellScriptBin "g++" ''
    exec ${pkgs.gcc}/bin/g++ "$@"
  '';
in
{
  home.packages = with pkgs; [
    rustc
    cargo
    rustfmt
    clippy

    go
    nodejs
    bun
    pnpm
    python3
    python3Packages.huggingface-hub
    uv

    clang
    clang-tools
    gpp
    cmake
    ninja
    lldb
    unzip
    gnumake
    flex
    bison

    tree-sitter
    luarocks
    codexCli
  ];
}
