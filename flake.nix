{
  description = "rhappy dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."rhappy" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./nix/home.nix ];
      };

      apps.${system} = {
        switch = {
          type = "app";
          # スクリプトを生成して実行する
          program = builtins.toString (pkgs.writeShellScript "switch" ''
            # 自動で Git に変更を認識させる（これを忘れてエラーになるのを防ぐ）
            git -C ~/dotfiles add .
            
            # ホームディレクトリのパスを明示して反映を実行する
            nix run home-manager/master -- switch --flake ~/dotfiles/#rhappy
          '');
        };
      };
    };
}
