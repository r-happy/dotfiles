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
      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            claude-code-nix.overlays.default
          ];
        };

      mkHome =
        {
          system,
          module,
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs system;
          extraSpecialArgs = {
            inherit codex-cli-nix;
          };
          modules = [
            module
          ];
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

        specialArgs = {
          inherit codex-cli-nix;
        };

        modules = [
          ./nix/system-darwin.nix

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit codex-cli-nix;
            };
            home-manager.users.rhappy = import ./nix/darwin.nix;
          }
        ];
      };

      apps.${linuxSystem} = {
        switch = {
          type = "app";
          program = builtins.toString (
            linuxPkgs.writeShellScript "switch-linux" ''
              git -C ~/dotfiles add .
              nix run home-manager/master -- switch --flake ~/dotfiles#rhappy-linux
            ''
          );
        };
      };

      apps.${darwinSystem} = {
        switch = {
        type = "app";
        program = builtins.toString (
          darwinPkgs.writeShellScript "switch-darwin" ''
            git -C ~/dotfiles add .
            sudo -H nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake /Users/rhappy/dotfiles#${darwinHost}
          ''
        );
      };
    };
  };
}
