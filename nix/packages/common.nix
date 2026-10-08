{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    fd

    ghq
    fzf
    eza

    openssh

    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
  ];
}
