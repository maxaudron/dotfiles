{ config, lib, pkgs, ... }:

{
  services.udev.extraRules = ''
    SUBSYSTEM=="kvmfr", OWNER="audron", GROUP="users", MODE="0666"
  '';

  boot = {
    zfs = {
      forceImportRoot = false;
      devNodes = "/dev/";
    };

    initrd = {
      availableKernelModules =
        [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };

    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod;

    kernelModules = [ "kvm-amd" "amdgpu" "zfs" ];

    # Use the systemd-boot EFI boot loader.
    supportedFilesystems = [ "zfs" ];

    loader = {
      efi = { canTouchEfiVariables = true; };

      # Use the GRUB 2 boot loader.
      grub = {
        enable = true;
        zfsSupport = true;
        efiSupport = true;
        device = "nodev";

        # Force this list to only contain these entries
        # by default /boot is in here too, breaking my setup
        mirroredBoots = lib.mkForce [
          {
            devices = [ "/dev/nvme0n1" ];
            path = "/boot/1";
          }
          {
            devices = [ "/dev/nvme1n1" ];
            path = "/boot/2";
          }
        ];

        memtest86.enable = true;
      };
    };
  };

  services.zfs = {
    trim.enable = true;
    autoScrub = {
      enable = true;
      pools = [ "rpool" "storage" ];
    };
  };

  systemd.services.zfs-mount.enable = false;

  fileSystems."/" = {
    device = "rpool/root";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/nix" = {
    device = "rpool/root/nix";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/etc" = {
    device = "rpool/root/etc";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/home" = {
    device = "rpool/root/home";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/srv" = {
    device = "rpool/root/srv";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/var" = {
    device = "rpool/root/var";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/var/lib" = {
    device = "rpool/root/var/lib";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/var/lib/containers" = {
    device = "rpool/root/var/lib/containers";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/var/log" = {
    device = "rpool/root/var/log";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/var/spool" = {
    device = "rpool/root/var/spool";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/boot/1" = {
    device = "/dev/disk/by-id/nvme-WDS100T1X0E-00AFY0_2152BE442809-part2";
    fsType = "vfat";
    options = [ "X-mount.mkdir" ];
  };

  fileSystems."/boot/2" = {
    device = "/dev/disk/by-id/nvme-WDS100T1X0E-00AFY0_2152BE442510-part2";
    fsType = "vfat";
    options = [ "X-mount.mkdir" ];
  };

  fileSystems."/share" = {
    device = "storage/share";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };
  
  fileSystems."/mnt/games" = {
    device = "storage/games";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = false;
}
