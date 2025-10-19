{
  config,
  lib,
  pkgs,
  textfox,
  ...
}:

{
  imports = [ textfox.homeManagerModules.default ];

  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [ pkgs.browserpass ];

    profiles = {
      "3xmsqkrh.default" = {
        name = "default";
        path = "3xmsqkrh.default";
        extensions = {
          force = true;
          settings."FirefoxColor@mozilla.com" = {
            settings = {
              firstRunDone = true;
              theme = {
                colors = {
                  frame = lib.mkForce {
                    "b" = 46;
                    "g" = 30;
                    "r" = 30;
                  };
                  frame_inactive = lib.mkForce {
                    "b" = 46;
                    "g" = 30;
                    "r" = 30;
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  textfox = {
    enable = true;
    profile = "3xmsqkrh.default";
    config = {
      displayWindowControls = false;
      displayNavButtons = false;
      displayUrlbarIcons = true;
      displaySidebarTools = false;
      displayTitles = false;

      border = {
        width = "2px";
        radius = "10px";
      };

      tabs = {
        horizontal.enable = false;
        vertical = {
          enable = true;
          margin = "0.2rem";
        };
      };
    };
  };
}
