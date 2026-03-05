{
  description = "rhappy dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."rhappy" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./nix/home.nix ];
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
