{ ... }:

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

  # Login with greetd + the DMS greeter, so the login screen is the same shell
  # as the bar and the lock screen. The module runs the greeter inside a nested
  # niri (programs.niri.enable in nix/system/nixos.nix) and sets
  # services.greetd itself, hence no greetd block here. GDM was tried first and
  # left niri on a grey screen on this machine; `niri-session` from a TTY works,
  # and so does greetd.
  #
  # configHome makes greetd's preStart copy settings.json, session.json and the
  # custom theme out of the user's home into /var/lib/dms-greeter, which is what
  # carries Tawny and the wallpaper over to the login screen. Those files are
  # read-only store symlinks (nix/modules/dms.nix); preStart copies contents,
  # so that is fine. Sessions (niri / GNOME) are listed from XDG_DATA_DIRS,
  # which pam_env sets for the greeter from /etc/pam/environment.
  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri";
    configHome = "/home/${settings.username}";

    # Replaces the config the dms-greeter wrapper would have written
    # (Modules/Greetd/assets/dms-greeter), so everything it puts there has to be
    # repeated: DMS_RUN_GREETER is what makes quickshell come up as the greeter
    # instead of the shell, and the wrapper appends its own spawn-at-startup
    # afterwards either way. Only the input block is ours — the keyboard is JIS
    # and the wrapper's config leaves niri on the "us" default, which would put
    # the symbols in a password under the wrong keys. Same layouts and options
    # as config/niri/config.kdl.
    compositor.customConfig = ''
      input {
          keyboard {
              xkb {
                  layout "jp,us"
                  options "ctrl:nocaps"
              }
          }
      }

      hotkey-overlay {
          skip-at-startup
      }

      environment {
          DMS_RUN_GREETER "1"
      }

      debug {
          keep-max-bpc-unchanged
      }

      gestures {
          hot-corners {
              off
          }
      }

      layout {
          background-color "#000000"
      }
    '';
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
