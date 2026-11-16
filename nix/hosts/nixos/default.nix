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

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  users.users.${settings.username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  # Release the machine was first installed with. Do not change.
  system.stateVersion = "26.05";
}
