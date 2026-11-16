{ pkgs, ... }:

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
  console.keyMap = "jp106";
  services.xserver.xkb.layout = "jp";

  # GDM shows a session picker (niri / GNOME) on the login screen.
  # GNOME is kept as a fallback desktop; remove it once niri is settled.
  services.displayManager.gdm.enable = true;
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
    ];
  };

  # Release the machine was first installed with. Do not change.
  system.stateVersion = "26.05";
}
