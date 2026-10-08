{
  description = "rhappy dotfiles";

  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    # Keep its tested unstable nixpkgs instead of following our stable input.
    llm-agents.url = "github:numtide/llm-agents.nix";

    fish-ghq-fzf = {
      url = "github:yuys13/fish-ghq-fzf";
      flake = false;
    };
    fish-autols = {
      url = "github:yuys13/fish-autols";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim-config = {
      url = "github:r-happy/nixvim-config";
      inputs.tawnyNvim.follows = "tawnyNvim";
    };
    tawnyNvim = {
      url = "github:r-happy/tawny.nvim";
      flake = false;
    };
  };

  outputs = inputs:
    let
      settings = import ./nix/lib/settings.nix;
      specialArgs = { inherit inputs; };
      pkgsFor = system: import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      linuxHome = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor settings.systems.linux;
        extraSpecialArgs = specialArgs;
        modules = [ ./nix/home/linux.nix ];
      };
    in
    {
      homeConfigurations = {
        "${settings.username}" = linuxHome;
        "${settings.username}-linux" = linuxHome;
      };
      darwinConfigurations.${settings.hosts.darwin} = inputs.nix-darwin.lib.darwinSystem {
        pkgs = pkgsFor settings.systems.darwin;
        inherit specialArgs;
        modules = [ ./nix/system/darwin.nix ];
      };
      apps = import ./nix/switch.nix { inherit inputs settings; };
    };
}
