{ inputs, settings }:

let
  app = system: script: {
    type = "app";
    program = toString (inputs.nixpkgs.legacyPackages.${system}.writeShellScript "switch" script);
  };
  linux = app settings.systems.linux ''
    ${inputs.home-manager.packages.${settings.systems.linux}.home-manager}/bin/home-manager switch \
      --flake path:${inputs.self.outPath}#${settings.username}-linux \
      --override-input nixvim-config path:${inputs.nixvim-config.outPath}
  '';
  darwin = app settings.systems.darwin ''
    sudo -H ${inputs.nix-darwin.packages.${settings.systems.darwin}.darwin-rebuild}/bin/darwin-rebuild switch \
      --flake path:${inputs.self.outPath}#${settings.hosts.darwin} \
      --override-input nixvim-config path:${inputs.nixvim-config.outPath}
  '';
in
{
  ${settings.systems.linux} = { switch = linux; default = linux; };
  ${settings.systems.darwin} = { switch = darwin; default = darwin; };
}
