{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (mactop.overrideAttrs (_: {
      doCheck = false;
    }))
    reattach-to-user-namespace
  ];
}
