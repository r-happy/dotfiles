{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.username = "rhappy";
  home.homeDirectory = "/home/rhappy";
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    fastfetch
    ripgrep
    fd
    bat
    chafa

    rustc
    cargo
    rustfmt
    clippy

    go
    nodejs
    bun
    pnpm
    python3

    clang
    gnumake

    tree-sitter
    luarocks

    wl-clipboard

    docker
    docker-compose
  ];

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "r-happy";
        email = "106812882+r-happy@users.noreply.github.com";
      };
    };
  };

  programs.gh.enable = true;
  programs.lazygit.enable = true;

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "pure";
        src = pkgs.fishPlugins.pure.src;
      }
    ];
    shellInit = ''
      fish_add_path ~/.nix-profile/bin
      fish_add_path /nix/var/nix/profiles/default/bin
    '';
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

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
          set -g @ukiyo-theme "kanagawa/wave"
          set -g @ukiyo-show-powerline true
          set -g @ukiyo-background "default"
        '';
      }
    ];

    extraConfig = builtins.readFile ../config/tmux/tmux.conf;
  };

  home.file = {
    ".config/nvim" = {
      source = ../config/nvim;
      recursive = true;
    };
  };
}
