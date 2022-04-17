{ config, lib, pkgs, ... }:

with lib;

let
  startWindowsDesktopItem = pkgs.makeDesktopItem {
    name = "start-windows";
    desktopName = "Start Windows VM";
    exec = "${pkgs.libvirt}/bin/virsh -c qemu:///system start windows";
  };
  stopWindowsDesktopItem = pkgs.makeDesktopItem {
    name = "stop-windows";
    desktopName = "Stop Windows VM";
    exec = "${pkgs.libvirt}/bin/virsh -c qemu:///system destroy windows";
  };

  cfg = config.vfio;
in {
  options.vfio = {
    devices = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        PCIe device addresses that the vfio-pci kernel module will be attached to
        can be retrieved using <literal>lspci</literal>.
      '';
      example = [ "0000:09:00.0" "0000:09:00.1" "0000:0e:00.3" ];
    };

    user = mkOption {
      type = types.str;
      default = "audron";
      description = ''
        Username of the main user. VM will be run as this user.
      '';
      example = "audron";
    };

    userID = mkOption {
      type = types.int;
      default = 1000;
      description = ''
        User id of the main user. VM will be run as this user.
      '';
      example = 1000;
    };
  };

  config = {
    boot = {
      kernelParams = [ "amd_iommu=on" "video=efifb:off" ];

      kernel.sysctl = {
        "vm.nr_hugepages" = 8129;
        "kernel.shmmax" = 18035507200;
      };

      kernelModules = [ "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
      blacklistedKernelModules = [ "nvidia" "nvidiafb" "nouveau" ];

      extraModprobeConfig = ''
        options vfio-pci disable_vga=0
        options vfio-pci disable_idle_d3=0
      '';

      postBootCommands = ''
        #!/bin/sh

        DEVS="${concatStringsSep " " cfg.devices}"

        if [ ! -z "$(ls -A /sys/class/iommu)" ]; then
            for DEV in $DEVS; do
                echo "$DEV" > /sys/bus/pci/devices/$DEV/driver/unbind
                echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
            done
        fi

        modprobe -i vfio_pci
      '';
    };

    environment.systemPackages = with pkgs; [
      edk2
      virt-manager
      startWindowsDesktopItem
      stopWindowsDesktopItem
    ];

    virtualisation.libvirtd = {
      enable = true;

      onBoot = "ignore";
      onShutdown = "shutdown";

      extraConfig = ''
        user="${cfg.user}"
      '';

      qemu = {
        ovmf = { enable = true; };
        verbatimConfig = ''
          namespaces = []
          user = "+${toString cfg.userID}"
        '';
      };
    };
  };
}
