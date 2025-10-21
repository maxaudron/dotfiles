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
      "audron" = {
        name = "audron";
        path = "audron";
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
    profile = "audron";
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

  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird-bin;

    profiles = {
      "audron" = {
        isDefault = true;
      };
    };
  };
}
