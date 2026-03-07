{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "r-happy";
        email = "106812882+r-happy@users.noreply.github.com";
      };
      ghq = {
        root = "~/github";
      };
    };
  };

  programs.gh.enable = true;
  programs.lazygit.enable = true;
}
