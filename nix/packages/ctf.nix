{ lib, pkgs, ... }:

{
  home.packages =
    (with pkgs; [
      binwalk
      exiftool
      foremost
      radare2
      xxd

      nmap

      hashcat
      john

      gdb
      pwntools

      sqlmap
      zsteg
    ])
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.steghide ];
}
