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
in
{
  home.packages = with pkgs; [
    kitty
    swaybg
    brightnessctl
    playerctl
  ];

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
        "pulseaudio"
        "network"
        "backlight"
        "battery"
        "tray"
      ];
      "niri/window" = {
        max-length = 60;
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
