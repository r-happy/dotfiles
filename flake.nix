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
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          claude-code-nix.overlays.default
        ];
      };
    in
    {
      homeConfigurations."rhappy" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit codex-cli-nix;
        };
        modules = [
          ./nix/home.nix
        ];
      };

      apps.${system} = {
        switch = {
          type = "app";
          program = builtins.toString (
            pkgs.writeShellScript "switch" ''
              git -C ~/dotfiles add .
              nix run home-manager/master -- switch --flake ~/dotfiles/#rhappy
            ''
          );
        };
      };
    };
}
