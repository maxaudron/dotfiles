{ lib, pkgs, ... }:

{
  hardware.gpgSmartcards.enable = true;
  services.pcscd = {
    enable = true;
    plugins = lib.mkForce [ pkgs.unstable.ccid ];
  };

  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.udev.extraRules = ''
    # Token2 BIO+
    SUBSYSTEM=="usb", ATTR{idVendor}=="349e", ATTR{idProduct}=="0204", ENV{ID_SMARTCARD_READER}="1", ENV{ID_SMARTCARD_READER_DRIVER}="gnupg"
  '';

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.debian.pcsc-lite.access_card") {
        return polkit.Result.YES;
      }
    });

    polkit.addRule(function(action, subject) {
      if (action.id == "org.debian.pcsc-lite.access_pcsc") {
        return polkit.Result.YES;
      }
    });
  '';
}
