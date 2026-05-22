{
  pkgs,
  lib,
  codex-cli-nix,
  ...
}:

let
  codexCli = codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default;
  gpp = pkgs.writeShellScriptBin "g++" ''
    exec ${pkgs.gcc}/bin/g++ "$@"
  '';

  commonPackages = with pkgs; [
    fastfetch
    ripgrep
    fd
    bat
    chafa

    rustc
    cargo
    rustfmt
    clippy
    rustPlatform.rustLibSrc

    go
    nodejs
    bun
    pnpm
    python3
    opencode
    uv

    # C/C++ development
    clang
    clang-tools
    gpp
    cmake
    ninja
    lldb
    unzip
    gnumake

    tree-sitter
    luarocks
    codexCli

    ghq
    fzf
    eza

    openssh
    wget
    presenterm
    python3Packages.weasyprint

    # PDF utilities for text extraction and OCR
    poppler-utils
    tesseract
    ocrmypdf

    # CTF tools
    # 解析・フォレンジック
    binwalk
    exiftool
    foremost
    radare2
    xxd

    # ネットワーク
    nmap

    # 暗号・ハッシュ
    hashcat
    john

    # バイナリ解析・PWN
    gdb
    pwntools

    # Web
    sqlmap

    # ステガノグラフィ
    zsteg
  ];

  linuxOnlyPackages = with pkgs; [
    steghide
  ];
in
{
  home.sessionVariables = {
    RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
  };

  home.packages =
    commonPackages
    ++ lib.optionals pkgs.stdenv.isLinux linuxOnlyPackages;
}
