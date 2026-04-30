{
  pkgs,
  lib,
  codex-cli-nix,
  ...
}:

let
  codexCli = codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default;

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
    cmake
    ninja
    lldb
    unzip
    gnumake

    tree-sitter
    luarocks
    claude-code
    codexCli

    ghq
    fzf

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
  home.packages =
    commonPackages
    ++ lib.optionals pkgs.stdenv.isLinux linuxOnlyPackages;
}
