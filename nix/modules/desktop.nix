{
  lib,
  pkgs,
  inputs,
  ...
}:

# Linux desktop: niri, DMS (Dank Material Shell, see nix/system/nixos.nix for
# programs.dms-shell) and GTK, colored from tawny.nvim.
let
  tawny = import ../lib/tawny.nix {
    inherit lib;
    tawnyNvim = inputs.tawnyNvim;
  };
  t = tawny.theme;

  # UI font and terminal/monospace font (see fonts.fontconfig in
  # nix/system/nixos.nix for why these two go together).
  uiFont = "IBM Plex Sans JP";
  monoFont = "PlemolJP35 Console NF";

  # fcitx5 group per keyboard layout. Index order matches the niri xkb layouts ("jp,us").
  imGroups = [
    {
      name = "JIS";
      layout = "jp";
    }
    {
      name = "US";
      layout = "us";
    }
  ];

  # Mod+Space: next niri xkb layout, and the fcitx5 group with the same index.
  layoutToggle = pkgs.writeShellApplication {
    name = "niri-layout-toggle";
    runtimeInputs = [ pkgs.jq ];
    text = ''
      groups=(${lib.concatMapStringsSep " " (g: g.name) imGroups})
      count=''${#groups[@]}
      current=$(niri msg --json keyboard-layouts | jq '.current_idx')
      next=$(( (current + 1) % count ))
      niri msg action switch-layout "$next"
      fcitx5-remote -g "''${groups[$next]}" || true
    '';
  };

  # Mod+Alt+Up/Down/0: change the focused output's scale at runtime.
  scaleStep = pkgs.writeShellApplication {
    name = "niri-scale";
    runtimeInputs = [ pkgs.jq ];
    text = ''
      steps=(1 1.25 1.5 1.75 2 2.5 3)
      output=$(niri msg --json focused-output)
      name=$(jq -r '.name' <<<"$output")
      scale=$(jq -r '.logical.scale' <<<"$output")

      idx=0
      for i in "''${!steps[@]}"; do
        if awk -v a="''${steps[$i]}" -v b="$scale" 'BEGIN { exit !(a <= b + 0.001) }'; then
          idx=$i
        fi
      done

      case "''${1:-up}" in
        up) idx=$(( idx + 1 < ''${#steps[@]} ? idx + 1 : idx )) ;;
        down) idx=$(( idx > 0 ? idx - 1 : 0 )) ;;
        reset) idx=0 ;;
        *) echo "usage: niri-scale up|down|reset" >&2; exit 1 ;;
      esac

      niri msg output "$name" scale "''${steps[$idx]}"
      notify-send -t 1500 "Scale" "$name: ''${steps[$idx]}" || true
    '';
  };
in
{
  home.packages = with pkgs; [
    layoutToggle
    scaleStep
    libnotify
    kitty
    brightnessctl
    playerctl
    # GUI settings that work outside GNOME
    pavucontrol
    discord
    inputs.zen-browser.packages.${pkgs.system}.default
  ];

  # fcitx5 groups: JIS / US, each with Mozc. Mozc follows the group's layout.
  # Ctrl+Space or 全角/半角 toggles Japanese; 変換 / 無変換 turn it on / off.
  # force: fcitx5 rewrites these files on exit; Nix stays the source of truth.
  xdg.configFile."fcitx5/profile" = {
    force = true;
    text = lib.generators.toINI { } (
      lib.foldl' (a: b: a // b) { } (
        lib.imap0 (i: g: {
          "Groups/${toString i}" = {
            Name = g.name;
            "Default Layout" = g.layout;
            DefaultIM = "mozc";
          };
          "Groups/${toString i}/Items/0" = {
            Name = "keyboard-${g.layout}";
            Layout = "";
          };
          "Groups/${toString i}/Items/1" = {
            Name = "mozc";
            Layout = "";
          };
        }) imGroups
      )
      // {
        GroupOrder = lib.listToAttrs (lib.imap0 (i: g: lib.nameValuePair (toString i) g.name) imGroups);
      }
    );
  };
  xdg.configFile."fcitx5/config" = {
    force = true;
    text = lib.generators.toINI { } {
      "Hotkey/TriggerKeys" = {
        "0" = "Control+space";
        "1" = "Zenkaku_Hankaku";
      };
      "Hotkey/ActivateKeys"."0" = "Henkan_Mode";
      "Hotkey/DeactivateKeys"."0" = "Muhenkan";
      # Mod+Space is handled by niri (niri-layout-toggle).
      "Hotkey/EnumerateGroupForwardKeys" = { };
      "Hotkey/EnumerateGroupBackwardKeys" = { };
    };
  };

  xdg.configFile."niri/config.kdl".text =
    builtins.replaceStrings
      [ "@accent@" "@accentSoft@" "@container@" "@inactive@" "@urgent@" ]
      [ t.accent "${t.accent}80" t.accentContainer t.selectionBackground t.error ]
      (builtins.readFile ../../config/niri/config.kdl);

  # waybar/fuzzel/mako were replaced by DMS (programs.dms-shell, nix/system/nixos.nix),
  # which provides the bar, launcher and notifications as one shell. DMS's own
  # settings live in nix/modules/dms.nix; the wallpaper is handed to it there
  # (it draws it on its background layer, so there is no swaybg here).

  gtk = {
    enable = true;
    font = {
      name = uiFont;
      size = 11;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    # GTK4/libadwaita follows the color-scheme below instead.
    gtk4.theme = null;
  };
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    font-name = "${uiFont} 11";
    document-font-name = "${uiFont} 11";
    monospace-font-name = "${monoFont} 11";
  };
}
