{ lib, pkgs, inputs, ... }:

let
  tawny = import ../lib/tawny.nix {
    inherit lib;
    tawnyNvim = inputs.tawnyNvim;
  };
  tawnyTheme = tawny.theme;
  color1 = builtins.elemAt tawnyTheme.palette 1;
  color3 = builtins.elemAt tawnyTheme.palette 3;
  color8 = builtins.elemAt tawnyTheme.palette 8;
  surface0 = tawnyTheme.background;
  surface1 = tawnyTheme.selectionBackground;
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
      # Muted Powerline segments using the tawny.nvim background colors.
      set -g status-style "bg=${surface0},fg=${color8}"
      set -g status-left-length 50
      set -g status-right-length 80
      set -g status-left \
        "#[bg=${surface1},fg=${tawnyTheme.foreground},bold] #S #[bg=${surface0},fg=${surface1},nobold] "
      set -g status-right \
        "#[bg=${surface0},fg=${color8},nobold] #h #[bg=${surface0},fg=${surface1}]#[bg=${surface1},fg=${color8}] %Y-%m-%d  #[fg=${tawnyTheme.foreground}]%H:%M "

      set -g window-status-separator ""
      set -g window-status-format \
        "#[bg=${surface0},fg=${color8},nobold] #{b:pane_current_path}  #I #W#F "
      set -g window-status-current-format \
        "#[bg=${surface1},fg=${surface0},nobold]#[fg=${color8}] #{b:pane_current_path} #[fg=${tawnyTheme.foreground},bold] #I #W#F #[bg=${surface0},fg=${surface1},nobold]"
      set -g window-status-activity-style "bg=${surface0},fg=${color3}"
      set -g window-status-bell-style "bg=${surface0},fg=${color1}"

      set -g pane-border-style "fg=${surface1}"
      set -g pane-active-border-style "fg=${color8}"
      set -g message-style "bg=${surface1},fg=${tawnyTheme.foreground}"
      set -g message-command-style "bg=${surface1},fg=${color8}"
      set -g mode-style "bg=${surface1},fg=${tawnyTheme.foreground}"
    '';
  };
}
