{ config, pkgs, ... }:

let
  settings = import ../../lib/settings.nix;
in
{
  imports = [
    # Generated on the machine by the installer / `nixos-generate-config`.
    # Copy it from /etc/nixos/hardware-configuration.nix.
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = settings.hosts.nixos;
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "ja_JP.UTF-8";
  services.xserver.xkb = {
    layout = "jp";
    options = "ctrl:nocaps";
  };
  console.useXkbConfig = true;

  # Login with greetd + tuigreet. niri did not start from GDM on this machine
  # (grey screen), while `niri-session` from a TTY works.
  # F3 on the login screen picks the session (niri / GNOME).
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = builtins.concatStringsSep " " [
        "${pkgs.tuigreet}/bin/tuigreet"
        "--time"
        "--remember"
        "--remember-session"
        "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"
        "--cmd niri-session"
      ];
      user = "greeter";
    };
  };

  # GNOME is kept as a fallback desktop; remove it once niri is settled.
  services.desktopManager.gnome.enable = true;

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.firefox.enable = true;

  users.users.${settings.username} = {
    isNormalUser = true;
    description = settings.username;
    extraGroups = [
      "wheel"
      "networkmanager"
      # Talks to the Docker daemon socket without sudo
      # (virtualisation.docker in nix/system/nixos.nix).
      "docker"
    ];
  };

  # Release the machine was first installed with. Do not change.
  system.stateVersion = "26.05";
}
