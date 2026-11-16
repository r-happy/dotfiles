{
  lib,
  pkgs,
  inputs,
  ...
}:

# Linux desktop: niri, waybar, fuzzel, mako, wallpaper and GTK, colored from tawny.nvim.
let
  tawny = import ../lib/tawny.nix {
    inherit lib;
    tawnyNvim = inputs.tawnyNvim;
  };
  t = tawny.theme;
  c = index: builtins.elemAt t.palette index;
  bare = color: lib.removePrefix "#" color;

  wallpaper = ../../assets/wallpaper.jpg;
  font = "PlemolJP35 Console NF";

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
    swaybg
    brightnessctl
    playerctl
    # GUI settings that work outside GNOME
    pavucontrol
    networkmanagerapplet
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

  # Wi-Fi icon in the waybar tray.
  services.network-manager-applet.enable = true;

  xdg.configFile."niri/config.kdl".text =
    builtins.replaceStrings
      [ "@accent@" "@inactive@" "@wallpaper@" ]
      [ t.accent t.selectionBackground "${wallpaper}" ]
      (builtins.readFile ../../config/niri/config.kdl);

  programs.waybar = {
    enable = true;
    settings.main = {
      layer = "top";
      position = "top";
      height = 30;
      spacing = 4;
      modules-left = [
        "niri/workspaces"
        "niri/window"
      ];
      modules-center = [ "clock" ];
      modules-right = [
        "niri/language"
        "pulseaudio"
        "network"
        "backlight"
        "battery"
        "tray"
      ];
      "niri/window" = {
        max-length = 60;
      };
      "niri/language" = {
        format = "kbd {short}";
      };
      clock = {
        format = "{:%m/%d (%a) %H:%M}";
        tooltip-format = "<tt>{calendar}</tt>";
      };
      pulseaudio = {
        format = "vol {volume}%";
        format-muted = "vol muted";
        on-click = "pavucontrol";
      };
      network = {
        format-wifi = "wifi {essid}";
        format-ethernet = "eth";
        format-disconnected = "offline";
        tooltip-format = "{ifname} {ipaddr}";
        on-click = "nm-connection-editor";
      };
      backlight = {
        format = "bri {percent}%";
      };
      battery = {
        format = "bat {capacity}%";
        format-charging = "bat {capacity}% +";
        states = {
          warning = 30;
          critical = 15;
        };
      };
      tray.spacing = 8;
    };
    style = ''
      * {
        font-family: "${font}", sans-serif;
        font-size: 13px;
        min-height: 0;
        border: none;
        border-radius: 0;
      }

      window#waybar {
        background: ${t.background};
        color: ${t.foreground};
        border-bottom: 1px solid ${t.selectionBackground};
      }

      #workspaces button {
        padding: 0 8px;
        color: ${c 8};
        background: transparent;
      }

      #workspaces button.active,
      #workspaces button.focused {
        color: ${t.background};
        background: ${t.accent};
      }

      #workspaces button.urgent {
        color: ${t.background};
        background: ${c 1};
      }

      #window {
        padding: 0 10px;
        color: ${c 8};
      }

      #clock {
        color: ${t.accent};
        font-weight: bold;
      }

      #language,
      #pulseaudio,
      #network,
      #backlight,
      #battery,
      #tray {
        padding: 0 10px;
        color: ${t.foreground};
      }

      #pulseaudio.muted,
      #network.disconnected {
        color: ${c 8};
      }

      #battery.warning {
        color: ${c 3};
      }

      #battery.critical:not(.charging) {
        color: ${c 1};
      }

      tooltip {
        background: ${t.titlebarBackground};
        border: 1px solid ${t.selectionBackground};
      }
    '';
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "${font}:size=12";
        terminal = "kitty";
        width = 40;
        lines = 12;
        horizontal-pad = 16;
        vertical-pad = 12;
      };
      colors = {
        background = "${bare t.background}f2";
        text = "${bare t.foreground}ff";
        prompt = "${bare t.accent}ff";
        input = "${bare t.foreground}ff";
        match = "${bare t.accent}ff";
        selection = "${bare t.selectionBackground}ff";
        selection-text = "${bare t.foreground}ff";
        selection-match = "${bare t.accent}ff";
        border = "${bare t.accent}ff";
      };
      border = {
        width = 2;
        radius = 6;
      };
    };
  };

  services.mako = {
    enable = true;
    settings = {
      font = "${font} 11";
      background-color = t.background;
      text-color = t.foreground;
      border-color = t.accent;
      border-size = 2;
      border-radius = 6;
      default-timeout = 5000;
    };
  };

  gtk = {
    enable = true;
    font = {
      name = "PlemolJP";
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
    font-name = "PlemolJP 11";
    document-font-name = "PlemolJP 11";
    monospace-font-name = "${font} 11";
  };
}
