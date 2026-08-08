[
  (_final: prev: {
    unpaper = prev.unpaper.overrideAttrs (_old: {
      doCheck = false;
    });

    # macOS 27 CoreText differs from the expected output in HarfBuzz's
    # shape+in-house test.  Limit the test workaround to the ICU variant
    # used by texliveFull on Darwin.
    harfbuzzFull = if prev.stdenv.hostPlatform.isDarwin then
      prev.harfbuzzFull.overrideAttrs (_old: {
        doCheck = false;
      })
    else prev.harfbuzzFull;

    john = prev.john.overrideAttrs (old: {
      src = old.src.override {
        hash = "sha256-zO1/KUJe3LvYCGlwVpNg5uDwPRD0ql/7anErb7tywC0=";
      };
    });
  })
]
