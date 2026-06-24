{ lib, pkgs, tawnyNvim, ... }:

let
  tawny = import ./lib/tawny.nix {
    inherit lib tawnyNvim;
  };
  tawnyTheme = tawny.theme;
  color0 = builtins.elemAt tawnyTheme.palette 0;
  color1 = builtins.elemAt tawnyTheme.palette 1;
  color3 = builtins.elemAt tawnyTheme.palette 3;
  color7 = builtins.elemAt tawnyTheme.palette 7;
  color8 = builtins.elemAt tawnyTheme.palette 8;
  surface0 = tawnyTheme.background;
  surface1 = tawnyTheme.selectionBackground;

  baseConfig = builtins.readFile ../config/tmux/tmux.conf;

  tmuxTheme = ''
    # Managed by Home Manager. Colors sourced from tawny.nvim.
    set -g status-style                  "bg=${color0},fg=${color8}"
    set -g status-left-length            50
    set -g status-right-length           80

    set -g status-left \
      "#[bg=${surface1},fg=${tawnyTheme.foreground},bold] #S #[bg=${color0},fg=${color8},nobold] "

    set -g status-right \
      "#[bg=${surface1},fg=${color0}]#[bg=${surface1},fg=${color7}] #h #[bg=${color8},fg=${surface1}]#[bg=${color8},fg=${surface0}] %Y-%m-%d  %H:%M "

    set -g window-status-format \
      "#[bg=${color0},fg=${color8}] #{b:pane_current_path}  #I #W#F "

    set -g window-status-current-format \
      "#[bg=${color8},fg=${color0}]#[bg=${color8},fg=${surface0},bold] #{b:pane_current_path} #[bg=${surface1},fg=${color8}]#[bg=${surface1},fg=${tawnyTheme.foreground},bold] #I #W#F #[bg=${color0},fg=${surface1}]"

    set -g window-status-activity-style  "bg=${color0},fg=${color3}"
    set -g window-status-bell-style      "bg=${color0},fg=${color1}"

    set -g pane-border-style             "fg=${surface1}"
    set -g pane-active-border-style      "fg=${color8}"

    set -g message-style                 "bg=${surface1},fg=${tawnyTheme.foreground}"
    set -g message-command-style         "bg=${surface1},fg=${color8}"

    set -g mode-style                    "bg=${surface1},fg=${tawnyTheme.foreground}"
  '';
in

{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    prefix = "C-t";
    keyMode = "vi";
    mouse = true;
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      pain-control
      logging
      yank
    ];

    extraConfig = baseConfig + "\n" + tmuxTheme;
  };
}
