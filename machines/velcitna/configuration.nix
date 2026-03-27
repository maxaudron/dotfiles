# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "velcitna";

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  users.users.${config.my.user.name}.extraGroups = [ "networkmanager" ];

  services.displayManager.autologin = {
    enable = false;
    user = config.users.users.audron.name;
  };

  services.displayManager.lemurs = {
    enable = true;
    settings = { };
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  services.tlp.enable = true;

  system.stateVersion = "25.11"; # Did you read the comment?
}
