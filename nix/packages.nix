{ pkgs, codex-cli-nix, ... }:

{
  home.packages = with pkgs; [
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

    clang
    unzip
    gnumake

    tree-sitter
    luarocks
    claude-code
    codex-cli-nix.packages.${pkgs.system}.default

    wl-clipboard

    ghq
    fzf

    docker
    docker-compose
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
    wireshark-cli
    tcpdump
    netcat-gnu

    # 暗号・ハッシュ
    hashcat
    john

    # バイナリ解析・PWN
    gdb
    patchelf
    pwntools
    strace
    ltrace

    # Web
    sqlmap

    # ステガノグラフィ
    steghide
    zsteg
  ];
}
