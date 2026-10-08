{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (mactop.overrideAttrs (old: {
      # Use upstream's CI guard to skip the hardware-dependent integration test.
      preCheck = (old.preCheck or "") + ''
        export CI=1
      '';
    }))
    reattach-to-user-namespace
  ];
}
