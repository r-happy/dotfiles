{ pkgs, ... }:

{
  imports = [
    ./shared.nix
    ./packages/darwin.nix
  ];

  xdg = {
    enable = true;
    configFile."opencode/opencode.json".text = builtins.toJSON {
      "$schema" = "https://opencode.ai/config.json";

      provider = {
        omlx = {
          npm = "@ai-sdk/openai-compatible";
          name = "oMLX";

          options = {
            baseURL = "http://127.0.0.1:8000/v1";
          };

          models = {
            "Qwen3.5-9B-MLX-4bit" = {
              name = "Qwen3.5 9B MLX";
            };
          };
        };
      };
    };
  };
}
