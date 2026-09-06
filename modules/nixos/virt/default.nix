{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.my.virt = {
    enable = lib.mkEnableOption "";
  };

  config = lib.mkIf config.my.virt.enable {
    virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
    };

    environment.systemPackages = with pkgs; [ virt-manager ];
  };
}
