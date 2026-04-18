{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wl-clipboard
    docker
    docker-compose
    wireshark-cli
    tcpdump
    netcat-gnu
    patchelf
    strace
    ltrace
  ];
}
