{
  lib,
  config,
  pkgs,
  secrets,
  ...
}:

{
  options.my.progs.mail = {
    enable = lib.mkEnableOption "mail";
  };

  config = lib.mkIf config.my.progs.mail.enable {
    accounts.email.accounts = import "${secrets}/mail.nix" { inherit lib; };
    programs.meli = {
      enable = true;
      settings = {
        shortcuts = {
          general = {
            quit = "C-c";
            commands = [
              { command = [ "reload-config" ]; shortcut = "C-r"; }
            ];
          };
          listing = {
            exit_entry = "q";
          };
        };
      };
    };

    home.packages = with pkgs; [ w3m ];

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
