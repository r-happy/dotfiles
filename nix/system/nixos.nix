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
  # PAM stack for the DMS lock screen. DMS's Pam.qml asks for /etc/pam.d/dankshell
  # and falls back to /etc/pam.d/login only if that file is missing, so the name
  # is not ours to choose. An empty attrset is the standard NixOS stack
  # (pam_unix via unix_chkpwd), which is all the password field needs.
  security.pam.services.dankshell = { };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # Default terminal for anything that launches one on its own: DMS runs
  # Terminal=true desktop entries and its updater through $TERMINAL (falling
  # back to xterm), and Mod+T spawns the same binary from
  # config/niri/config.kdl. The package is in nix/modules/desktop.nix.
  environment.sessionVariables.TERMINAL = "ghostty";
  # Stem darkening. IBM Plex and PlemolJP are OTFs (CFF outlines), and FreeType
  # draws CFF stems at their mathematical width, which lands thinner than macOS
  # renders the same outline -- macOS emboldens as it rasterizes. Thin strokes
  # are exactly what reads as grain, and light-on-dark makes it worse, so turn
  # FreeType's emboldening on for both the CFF and the autofit rasterizers.
  # Double negative is FreeType's own naming: no-stem-darkening=0 means on.
  # See fonts.fontconfig in this file for the rest of the text rendering setup.
  environment.sessionVariables.FREETYPE_PROPERTIES =
    "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";

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

  # Text rendering. eDP-1 is a Sharp LQ134N1: 13.4" 1920x1200 = 168 DPI, driven
  # at scale 1, so a glyph gets far fewer pixels than on a Retina panel and the
  # antialiasing shows. Two knobs claw that back:
  #
  #   subpixel.rgba "rgb" - the panel is an RGB vertical-stripe LCD, so each
  #     pixel is three addressable stripes. Sampling them independently triples
  #     the horizontal resolution of the rasterizer. NixOS defaults this to
  #     "none" (grayscale, what macOS does) because it is wrong on OLED and on
  #     rotated panels; neither applies here. lcdfilter "default" (FIR5) is what
  #     keeps the extra resolution from turning into colour fringes.
  #
  #   hinting slight - vertical-only grid fitting. Keeps stems on pixel
  #     boundaries without distorting glyph shapes the way "full" does. This is
  #     already the NixOS default; pinned here so the three settings read
  #     together.
  #
  # The matching stem-darkening setting is FREETYPE_PROPERTIES, up with the
  # other session variables.
  fonts.fontconfig = {
    subpixel.rgba = "rgb";
    subpixel.lcdfilter = "default";
    hinting.enable = true;
    hinting.style = "slight";
  };

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
    # No swaylock/swayidle: DMS draws the lock screen itself and runs its own
    # idle monitor (Services/IdleService.qml, timeouts in nix/modules/dms.nix).
    swaybg
    xwayland-satellite
  ];
}
