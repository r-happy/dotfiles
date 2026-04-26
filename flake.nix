{
  description = "rhappy dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-code-nix.url = "github:sadjow/claude-code-nix";
    codex-cli-nix.url = "github:sadjow/codex-cli-nix";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-darwin,
      claude-code-nix,
      codex-cli-nix,
      ...
    }:
    let
      specialArgs = {
        inherit codex-cli-nix;
      };

      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = import ./nix/overlays.nix {
            inherit claude-code-nix;
          };
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
    {
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
          nix run home-manager/master -- switch --flake ~/dotfiles#rhappy-linux
        '';
      };

      apps.${darwinSystem} = {
        switch = mkSwitchApp darwinPkgs "switch-darwin" ''
          git -C ~/dotfiles add .
          sudo -H nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake /Users/rhappy/dotfiles#${darwinHost}
        '';
      };
    };
}
