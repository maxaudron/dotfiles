{
  config,
  lib,
  pkgs,
  textfox,
  ...
}:

{
  imports = [ textfox.homeManagerModules.default ];

  options.my.progs.firefox = {
    enable = lib.mkEnableOption "firefox";
  };

  config = lib.mkIf config.my.progs.firefox.enable {
    programs.chromium.enable = true;

    programs.firefox = {
      enable = true;
      nativeMessagingHosts = [ pkgs.browserpass ];

      profiles = {
        "audron" = {
          name = "audron";
          path = "audron";
        };
      };
    };

    textfox = {
      enable = true;
      profiles = [ "audron" ];
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
          };
        };
      };
    };

    programs.thunderbird = {
      enable = true;
      package = pkgs.thunderbird;

      profiles = {
        "audron" = {
          isDefault = true;
          settings = {
            "extensions.autoDisableScopes" = 0;
          };
        };
      };
    };
  };
}
