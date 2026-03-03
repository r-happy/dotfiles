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
	home.file = {
    		".config/nvim" = {
      			source = ../config/nvim;
      			recursive = true;
    		};
  	};
}
