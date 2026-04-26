{ claude-code-nix }:

[
  claude-code-nix.overlays.default

  (_final: prev: {
    ocrmypdf = prev.ocrmypdf.overridePythonAttrs (_old: {
      doCheck = false;
    });

    unpaper = prev.unpaper.overrideAttrs (_old: {
      doCheck = false;
    });
  })
]
