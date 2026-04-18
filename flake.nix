{
  description = "rhappy dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-code-nix.url = "github:sadjow/claude-code-nix";
    codex-cli-nix.url = "github:sadjow/codex-cli-nix";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      claude-code-nix,
      codex-cli-nix,
      ...
    }:
    let
      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
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
      linuxPkgs = mkPkgs linuxSystem;
      darwinPkgs = mkPkgs darwinSystem;
    in
    {
      homeConfigurations = {
        # Backward-compatible default for existing Linux usage.
        "rhappy" = mkHome {
          system = linuxSystem;
          module = ./nix/linux.nix;
        };

        "rhappy-linux" = mkHome {
          system = linuxSystem;
          module = ./nix/linux.nix;
        };

        "rhappy-darwin" = mkHome {
          system = darwinSystem;
          module = ./nix/darwin.nix;
        };
      };

      apps.${linuxSystem} = {
        switch = {
          type = "app";
          program = builtins.toString (
            linuxPkgs.writeShellScript "switch-linux" ''
              git -C ~/dotfiles add .
              nix run home-manager/master -- switch --flake ~/dotfiles/#rhappy-linux
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
              nix run home-manager/master -- switch --flake ~/dotfiles/#rhappy-darwin
            ''
          );
        };
      };
    };
}
