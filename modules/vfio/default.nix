{ config, lib, pkgs, ... }:

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
in {
  boot = {
    kernelParams = [
      "amd_iommu=on"
      "video=efifb:off"

      "hugepagesz=2MB"
      "hugepages=8192"
    ];

    kernel.sysctl = {
      "vm.nr_hugepages" = 8600;
      "kernel.shmmax" = 18035507200;
    };

    kernelModules = [ "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
    blacklistedKernelModules = [ "nvidia" "nvidiafb" "nouveau" ];

    postBootCommands = ''
      #!/bin/sh

      DEVS="0000:0e:00.0 0000:0e:00.1 0000:13:00.3"

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
      user="audron"
    '';

    qemu = {
      ovmf = { enable = true; };
      verbatimConfig = ''
        namespaces = []
        user = "+1000"
      '';
    };
  };
}
