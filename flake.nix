{
  description = "rhappy dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    codex-cli-nix.url = "github:sadjow/codex-cli-nix";
    nixvim-config.url = "github:r-happy/nixvim-config";
    tawnyNvim = {
      url = "github:r-happy/tawny.nvim";
      flake = false;
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nix-darwin,
      codex-cli-nix,
      ...
    }:
    let
      specialArgs = {
        inherit codex-cli-nix;
        nixvimConfig = inputs.nixvim-config;
        tawnyNvim = inputs.tawnyNvim;
      };

      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = import ./nix/overlays.nix;
        };

      mkHome =
        {
          system,
          module,
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs system;
          extraSpecialArgs = specialArgs;
          modules = [
            module
          ];
        };

      mkSwitchApp =
        pkgs: name: script:
        {
          type = "app";
          program = builtins.toString (
            pkgs.writeShellScript name script
          );
        };

      linuxSystem = "x86_64-linux";
      darwinSystem = "aarch64-darwin";
      darwinHost = "ReinoMacBook-Pro";

      linuxPkgs = mkPkgs linuxSystem;
      darwinPkgs = mkPkgs darwinSystem;
    in
    rec {
      homeConfigurations = {
        "rhappy" = mkHome {
          system = linuxSystem;
          module = ./nix/linux.nix;
        };

        "rhappy-linux" = mkHome {
          system = linuxSystem;
          module = ./nix/linux.nix;
        };
      };

      darwinConfigurations.${darwinHost} = nix-darwin.lib.darwinSystem {
        system = darwinSystem;
        pkgs = darwinPkgs;

        inherit specialArgs;

        modules = [
          ./nix/system-darwin.nix

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.rhappy = import ./nix/darwin.nix;
          }
        ];
      };

      apps.${linuxSystem} = {
        switch = mkSwitchApp linuxPkgs "switch-linux" ''
          git -C ~/dotfiles add .
          ${home-manager.packages.${linuxSystem}.home-manager}/bin/home-manager switch --flake ~/dotfiles#rhappy-linux
        '';
        default = apps.${linuxSystem}.switch;
      };

      apps.${darwinSystem} = {
        switch = mkSwitchApp darwinPkgs "switch-darwin" ''
          git -C ~/dotfiles add .
          sudo -H ${nix-darwin.packages.${darwinSystem}.darwin-rebuild}/bin/darwin-rebuild switch --flake /Users/rhappy/dotfiles#${darwinHost}
        '';
        default = apps.${darwinSystem}.switch;
      };
    };
}
