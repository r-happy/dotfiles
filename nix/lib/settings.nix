let
  repositories = "github";
in
{
  username = "rhappy";

  paths = {
    inherit repositories;
    memo = "${repositories}/memo";
    nixvimConfig = "${repositories}/nixvim-config";
  };

  git = {
    name = "r-happy";
    email = "106812882+r-happy@users.noreply.github.com";
    root = "~/${repositories}";
  };

  systems = {
    linux = "x86_64-linux";
    darwin = "aarch64-darwin";
  };

  hosts = {
    darwin = "ReinoMacBook-Pro";
  };

  homes = {
    linux = "/home/rhappy";
    darwin = "/Users/rhappy";
  };
}
