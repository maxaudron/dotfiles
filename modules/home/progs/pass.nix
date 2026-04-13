{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.my.progs.pass = {
    enable = lib.mkEnableOption "pass";
  };

  config = lib.mkIf config.my.progs.pass.enable {
    home.packages = with pkgs; [
      rage
      age-plugin-yubikey
    ];

    programs.password-store = {
      enable = true;
      # package = pkgs.passage;
      package = pkgs.pass.withExtensions (
        exts: with exts; [
          pass-update
          pass-otp
        ]
      );
      settings = {
        PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
        # PASSAGE_DIR = "$XDG_DATA_HOME/.password-store";
        # PASSAGE_AGE = "rage";
      };
    };
  };

}
