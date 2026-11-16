{
  description = "rhappy dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    fish-ghq-fzf = {
      url = "github:yuys13/fish-ghq-fzf";
      flake = false;
    };
    fish-autols = {
      url = "github:yuys13/fish-autols";
      flake = false;
    };

    # Tailscale widget for the DMS bar. Wired up in nix/system/nixos.nix
    # (programs.dms-shell.plugins) and enabled in nix/modules/dms.nix.
    dms-dankscale = {
      url = "github:dwright134/dms-dankscale";
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

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
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
      nixosConfigurations.${settings.hosts.nixos} = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          (./nix/hosts + "/${settings.hosts.nixos}")
          ./nix/system/nixos.nix
        ];
      };
      darwinConfigurations.${settings.hosts.darwin} = inputs.nix-darwin.lib.darwinSystem {
        pkgs = pkgsFor settings.systems.darwin;
        inherit specialArgs;
        modules = [ ./nix/system/darwin.nix ];
      };
      apps = import ./nix/switch.nix { inherit inputs settings; };
    };
}
