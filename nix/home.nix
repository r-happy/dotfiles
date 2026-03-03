{ config, pkgs, ... }:

{
	home.username = "rhappy";
	home.homeDirectory = "/home/rhappy";
	
	home.stateVersion = "23.11";

	home.packages = with pkgs; [
		fastfetch
		ripgrep
		fd
		bat


		go
		nodejs
		bun
		pnpm
		# clang
		gcc
		gnumake
		tree-sitter
		luarocks
		python3
		docker
		docker-compose
	];

	programs.home-manager.enable = true;

	# git
	programs.git = {
    	enable = true;
    	settings = {
      		user = {
        		name = "r-happy";
        		email = "106812882+r-happy@users.noreply.github.com";
      		};
    	};
  	};
    
    programs.gh = {
        enable = true;
    };
    
    programs.lazygit.enable = true;

	# fish
	programs.fish = {
		enable = true;
		plugins = [
			{
				name = "pure";
				src = pkgs.fishPlugins.pure.src;
			}
		];
	};

	# neovim
	programs.neovim = {
		enable = true;
		defaultEditor = true;
	};


    # tmux
    programs.tmux = {
        enable = true;
        shell = "${pkgs.fish}/bin/fish";
        terminal = "tmux-256color";
        prefix = "C-t";
        keyMode = "vi";
        mouse = true;

        plugins = with pkgs.tmuxPlugins; [
            sensible
            pain-control
            logging
            yank
            {
                plugin = mkTmuxPlugin {
                    pluginName = "ukiyo";
                    version = "unstable";
                    src = pkgs.fetchFromGitHub {
                    owner = "Nybkox";
                    repo = "tmux-ukiyo";
                    rev = "master";
                    hash = "sha256-jOcGNKb8QrIgT7l3D3RiJOPIC9JU1rOy8tk0x5ULrdc=";
                };
            };
        }
    ];

    extraConfig = ''
      # 既存の設定ファイルを読み込む
      source-file ~/.config/tmux/tmux.conf
    '';
    };


	home.file = {
    	".config/nvim" = {
      		source = ../config/nvim;
      		recursive = true;
    	};

    	".config/.tmux.conf".source = ../config/tmux/tmux.conf;
  	};
}
