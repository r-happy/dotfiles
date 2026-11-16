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
  programs.waybar.enable = true;
  security.polkit.enable = true;
  security.pam.services.swaylock = { };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Japanese input
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [ fcitx5-mozc ];
  };

  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    plemoljp-nf
  ];

  environment.systemPackages = with pkgs; [
    git
    gnumake
    alacritty
    fuzzel
    swaylock
    swayidle
    mako
    swaybg
    xwayland-satellite
  ];
}
