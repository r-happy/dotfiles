[
  (_final: prev: {
    unpaper = prev.unpaper.overrideAttrs (_old: {
      doCheck = false;
    });

    john = prev.john.overrideAttrs (old: {
      src = old.src.override {
        hash = "sha256-zO1/KUJe3LvYCGlwVpNg5uDwPRD0ql/7anErb7tywC0=";
      };
    });
  })
]
