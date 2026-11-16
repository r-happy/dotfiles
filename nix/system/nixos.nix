{ pkgs, inputs, ... }:

let
  settings = import ../lib/settings.nix;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  # Login shell. The user account itself is defined in nix/hosts/<host>/default.nix.
  programs.fish.enable = true;
  users.users.${settings.username}.shell = pkgs.fish;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = { inherit inputs; };
    users.${settings.username} = import ../home/linux.nix;
  };

  # niri (scrollable-tiling Wayland compositor)
  programs.niri.enable = true;
  security.polkit.enable = true;
  security.pam.services.swaylock = { };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # Default terminal for anything that launches one on its own: DMS runs
  # Terminal=true desktop entries and its updater through $TERMINAL (falling
  # back to xterm), and Mod+T spawns the same binary from
  # config/niri/config.kdl. The package is in nix/modules/desktop.nix.
  environment.sessionVariables.TERMINAL = "ghostty";

  # DMS (Dank Material Shell): bar, launcher, notifications and widgets for niri.
  # Starts itself via its own systemd user service (graphical-session.target).
  # Niri-side integration (environment vars, layer-rule) lives in
  # config/niri/config.kdl; DMS's own settings, theme and wallpaper are pinned in
  # nix/modules/dms.nix. `dms setup` is not needed.
  programs.dms-shell = {
    enable = true;
    # Installed to /etc/xdg/quickshell/dms-plugins/, which DMS scans alongside
    # ~/.config/DankMaterialShell/plugins. Enabled, and placed in the bar, in
    # nix/modules/dms.nix.
    plugins.Dankscale.src = inputs.dms-dankscale;
    enableSystemMonitoring = true;
    enableVPN = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
  };

  # Bluetooth (status shown in DMS; blueman-manager for GUI management).
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Tailscale. Run `sudo tailscale up` once to join the tailnet; the state then
  # lives in /var/lib/tailscale, outside this repo. Set
  # useRoutingFeatures = "client" if subnet routes or an exit node are needed.
  services.tailscale.enable = true;
  # Lets the login user drive `tailscale up/down/set` without root, which is
  # what the Dankscale bar widget needs. Applied by the tailscaled-set oneshot;
  # it only takes effect once the node is logged in.
  services.tailscale.extraSetFlags = [ "--operator=${settings.username}" ];

  # Docker Engine. Linux-only on purpose: the daemon is a Linux service, and on
  # macOS it would mean a VM (Docker Desktop / colima), so nix/system/darwin.nix
  # stays without it. This is the engine and the `docker` CLI only — per-project
  # clients, compose files and language toolchains stay in each project's
  # flake.nix.
  #
  # The login user is in the "docker" group (nix/hosts/nixos/default.nix) so
  # `docker` works without sudo; that group is root-equivalent, which is the
  # usual trade for a rootful daemon.
  virtualisation.docker = {
    enable = true;
    # Weekly `docker system prune`, so dangling images and build cache do not
    # grow unbounded in /var/lib/docker.
    autoPrune.enable = true;
  };

  # Japanese input
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [ fcitx5-mozc ];
  };

  fonts.packages = with pkgs; [
    ibm-plex
    plemoljp
    plemoljp-nf
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
  ];

  # IBM Plex Sans JP for the UI, PlemolJP for the terminal. PlemolJP is built
  # from IBM Plex Mono blended with IBM Plex Sans JP, so the proportional and
  # the monospace side are the same design, with Japanese drawn by the same
  # hand. Noto CJK still covers the glyphs Plex JP lacks.
  fonts.fontconfig.defaultFonts = {
    sansSerif = [
      "IBM Plex Sans JP"
      "Noto Sans CJK JP"
    ];
    serif = [
      "IBM Plex Serif"
      "Noto Serif CJK JP"
    ];
    monospace = [
      "PlemolJP35 Console NF"
      "PlemolJP Console"
    ];
    emoji = [ "Noto Color Emoji" ];
  };

  environment.systemPackages = with pkgs; [
    git
    gnumake
    alacritty
    swaylock
    swayidle
    swaybg
    xwayland-satellite
  ];
}
