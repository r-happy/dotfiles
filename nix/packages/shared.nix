{
  pkgs,
  lib,
  codex-cli-nix,
  ...
}:

let
  codexCli = codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default;
  # macOS 27's AMFI validates the Mach-O moved aside by wrapProgram.  Re-sign
  # it after wrapping, before the upstream completion-generation hook executes.
  opencodeDarwin = if pkgs.stdenv.isDarwin then pkgs.opencode.overrideAttrs (old: {
    env = (old.env or { }) // {
      OPENCODE_NIX_SKIP_DARWIN_SMOKE_TEST = "1";
    };
    postPatch = (old.postPatch or "") + ''
      substituteInPlace packages/opencode/script/build.ts \
        --replace-fail \
          "if (item.os === process.platform && item.arch === process.arch && !item.abi)" \
          "if (item.os === process.platform && item.arch === process.arch && !item.abi && !process.env.OPENCODE_NIX_SKIP_DARWIN_SMOKE_TEST)"
    '';
    postInstall = ''
      /usr/bin/codesign --force --sign - "$out/bin/.opencode-wrapped"
    '' + (old.postInstall or "");
  }) else pkgs.opencode;
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

    go
    nodejs
    bun
    pnpm
    python3
    python3Packages.huggingface-hub
    opencodeDarwin
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
    flex
    bison

    tree-sitter
    luarocks
    codexCli

    ghq
    fzf
    eza

    openssh
    wget
    presenterm
    texliveFull

    # PDF utilities for text extraction and OCR basics
    poppler-utils
    tesseract

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
  home.packages = commonPackages ++ lib.optionals pkgs.stdenv.isLinux linuxOnlyPackages;
}
