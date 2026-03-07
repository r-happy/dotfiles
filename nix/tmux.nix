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
      {
        plugin = mkTmuxPlugin {
          pluginName = "ukiyo";
          version = "unstable";
          rtp = "ukiyo.tmux";
          src = pkgs.fetchFromGitHub {
            owner = "Nybkox";
            repo = "tmux-ukiyo";
            rev = "master";
            hash = "sha256-jOcGNKb8QrIgT7l3D3RiJOPIC9JU1rOy8tk0x5ULrdc=";
          };
        };
        extraConfig = ''
          set -g @ukiyo-theme "kanagawa/dragon"
          set -g @ukiyo-show-powerline true
        '';
      }
    ];

    extraConfig = builtins.readFile ../config/tmux/tmux.conf;
  };
}
