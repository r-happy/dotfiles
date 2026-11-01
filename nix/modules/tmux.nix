{ lib, pkgs, inputs, ... }:

let
  tawny = import ../lib/tawny.nix {
    inherit lib;
    tawnyNvim = inputs.tawnyNvim;
  };
  tawnyTheme = tawny.theme;
  color1 = builtins.elemAt tawnyTheme.palette 1;
  color8 = builtins.elemAt tawnyTheme.palette 8;
  surface0 = tawnyTheme.background;
  surface1 = tawnyTheme.selectionBackground;
  accent = tawnyTheme.accent;
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

    extraConfig = builtins.readFile ../../config/tmux/tmux.conf + ''
      # Flat status bar on the terminal background: text color only, with
      # tawny reserved for the session name.
      set -g status-style "bg=${surface0},fg=${color8}"
      set -g status-left-length 50
      set -g status-right-length 80
      set -g status-left "#[fg=${accent},bold] #S #[fg=${color8},nobold] "
      set -g status-right "#[fg=${color8}]#h  %Y-%m-%d %H:%M "

      set -g window-status-separator ""
      set -g window-status-format \
        "#[fg=${color8},nobold] #{b:pane_current_path} #I #W#F "
      set -g window-status-current-format \
        "#[fg=${tawnyTheme.foreground},bold] #{b:pane_current_path} #I #W#F #[nobold]"
      set -g window-status-activity-style "bg=${surface0},fg=${accent}"
      set -g window-status-bell-style "bg=${surface0},fg=${color1}"

      set -g pane-border-style "fg=${surface1}"
      set -g pane-active-border-style "fg=${color8}"
      set -g message-style "bg=${surface1},fg=${tawnyTheme.foreground}"
      set -g message-command-style "bg=${surface1},fg=${color8}"
      set -g mode-style "bg=${surface1},fg=${tawnyTheme.foreground}"
    '';
  };
}
