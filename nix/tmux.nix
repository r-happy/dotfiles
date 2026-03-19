{ pkgs, ... }:

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

    extraConfig = builtins.readFile ../config/tmux/tmux.conf;
  };
}
