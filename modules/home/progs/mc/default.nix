{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.my.progs.mc = {
    enable = lib.mkEnableOption "mc";
  };

  config = lib.mkIf config.my.progs.mc.enable {
    home.packages = [ pkgs.chafa ];
    programs.mc = {
      enable = true;
    };

    programs.yazi = {
      enable = true;
      enableFishIntegration = true;

      keymap = {
        mgr = {
          prepend_keymap = [
            {
              on = [ "c" "t" ];
              run = "shell -- cp %h /share/private/!top";
              desc = "Copy Top";
            }
            {
              on = [ "c" "p" ];
              run = "shell -- cp %h /share/private/print";
              desc = "Copy Print";
            }
            {
              on = [ "c" "p" ];
              run = "shell -- cp %h /share/private/print";
              desc = "Copy Print";
            }
          ];
        };
      };
      settings = {
        preview = {
          max_width = 4000;
          max_height = 4000;
        };
      };
    };
  };
}
