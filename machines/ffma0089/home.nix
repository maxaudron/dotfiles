{ pkgs, ... }:

{
  my = {
    progs = {
      firefox.enable = true;
    };

    tools = {
      rust.enable = true;
      work.enable = true;
      go.enable = true;
    };
  };

  home.packages = [ pkgs.quasselClient ];
  home.stateVersion = "25.05";
}
