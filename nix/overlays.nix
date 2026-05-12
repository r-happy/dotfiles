[
  (_final: prev: {
    ocrmypdf = prev.ocrmypdf.overridePythonAttrs (_old: {
      doCheck = false;
    });

    unpaper = prev.unpaper.overrideAttrs (_old: {
      doCheck = false;
    });
  })
]
