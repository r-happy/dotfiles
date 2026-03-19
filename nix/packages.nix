{ pkgs, ... }:

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

    clang
    unzip
    gnumake

    tree-sitter
    luarocks
    claude-code

    wl-clipboard

    ghq
    fzf

    docker
    docker-compose

    wget

    # CTF tools
    # 解析・フォレンジック
    binwalk
    exiftool
    foremost
    radare2

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
