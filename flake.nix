{
  description = "rhappy dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    codex-cli-nix = {
      url = "github:sadjow/codex-cli-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nix-darwin,
      codex-cli-nix,
      ...
    }:
    let
      settings = import ./nix/lib/settings.nix;

      specialArgs = {
        inherit codex-cli-nix;
        nixvimConfig = inputs.nixvim-config;
        tawnyNvim = inputs.tawnyNvim;
      };

      mkPkgs = system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
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

      mkSwitchApp = pkgs: name: script: {
        type = "app";
        program = builtins.toString (pkgs.writeShellScript name script);
      };

      mkHomeEntry = system: module: {
        inherit system module;
      };

      linuxPkgs = mkPkgs settings.systems.linux;
      darwinPkgs = mkPkgs settings.systems.darwin;
    in
    rec {
      homeConfigurations = {
        "${settings.username}" = mkHome (mkHomeEntry settings.systems.linux ./nix/home/linux.nix);
        "${settings.username}-linux" = mkHome (mkHomeEntry settings.systems.linux ./nix/home/linux.nix);
      };

      darwinConfigurations.${settings.hosts.darwin} = nix-darwin.lib.darwinSystem {
        system = settings.systems.darwin;
        pkgs = darwinPkgs;

        inherit specialArgs;

        modules = [
          ./nix/system/darwin.nix

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.${settings.username} = import ./nix/home/darwin.nix;
          }
        ];
      };

      apps.${settings.systems.linux} = {
        switch = mkSwitchApp linuxPkgs "switch-linux" ''
          ${
            home-manager.packages.${settings.systems.linux}.home-manager
          }/bin/home-manager switch --flake path:${self.outPath}#${settings.username}-linux
        '';
        default = apps.${settings.systems.linux}.switch;
      };

      apps.${settings.systems.darwin} = {
        switch = mkSwitchApp darwinPkgs "switch-darwin" ''
          sudo -H ${
            nix-darwin.packages.${settings.systems.darwin}.darwin-rebuild
          }/bin/darwin-rebuild switch --flake path:${self.outPath}#${settings.hosts.darwin}
        '';
        default = apps.${settings.systems.darwin}.switch;
      };
    };
}
