{ config, lib, pkgs, builtins, ... }:

with lib;

let cfg = config.podman.machine;
    conf = import ../config { inherit lib; };
in {
  options.podman.machine = {
    name = mkOption {
      type = types.str;
      default = "default";
      example = "mymachine";
      description = "Name of the machine to be used with podman machine start/stop <name> etc.";
    };

    cpus = mkOption {
      type = types.int;
      default = 4;
      example = 4;
      description = "Number of CPU Cores";
    };

    memory = mkOption {
      type = types.int;
      default = 2048;
      example = 2048;
      description = "Memory for the virtual machine in MiB";
    };

    diskSize = mkOption {
      type = types.int;
      default = 100;
      example = 100;
      description = "Disk size for the virtual machine in GiB";
    };
  };

  config = {
    home.packages = [ pkgs.podman ];

    xdg = {
      enable = true;
      # configFile = {
      #   "containers/podman/machine/qemu/${cfg.name}.json".text = builtins.toJSON {
      #     CPUs = cfg.cpus;
      #     CmdLine = [
      #       "${pkgs.qemu}/bin/qemu-system-aarch64"
      #       "-m"
      #       "${toString cfg.memory}"
      #       "-smp"
      #       "${toString cfg.cpus}"
      #       "-fw_cfg"
      #       "name=opt/com.coreos/config,file=${conf.user.home}/.config/containers/podman/machine/qemu/${cfg.name}.ign"
      #       "-qmp"
      #       "unix:/${config.xdg.dataHome}/containers/podman/machine/${cfg.name}/qmp.sock,server=on,wait=off"
      #       "-netdev"
      #       "socket,id=vlan,fd=3"
      #       "-device"
      #       "virtio-net-pci,netdev=vlan,mac=5a:94:ef:e4:0c:ee"
      #       "-device"
      #       "virtio-serial"
      #       "-chardev"
      #       "socket,path=${config.xdg.dataHome}/containers/podman/machine/${cfg.name}/ready.sock,server=on,wait=off,id=${cfg.name}_ready"
      #       "-device"
      #       "virtserialport,chardev=${cfg.name}_ready,name=org.fedoraproject.port.0"
      #       "-accel"
      #       "hvf"
      #       "-accel"
      #       "tcg"
      #       "-cpu"
      #       "cortex-a57"
      #       "-M"
      #       "virt,highmem=off"
      #       "-drive"
      #       "file=${pkgs.qemu}/share/qemu/edk2-aarch64-code.fd,if=pflash,format=raw,readonly=on"
      #       "-drive"
      #       "file=${conf.user.home}/.local/share/containers/podman/machine/qemu/${cfg.name}_ovmf_vars.fd,if=pflash,format=raw"
      #       "-virtfs"
      #       "local,path=${conf.user.home},mount_tag=vol0,security_model=mapped-xattr"
      #       "-drive"
      #       "if=virtio,file=${conf.user.home}/.local/share/containers/podman/machine/qemu/${cfg.name}_fedora-coreos-36.20220421.dev.0-qemu.aarch64.qcow2"
      #     ];
      #     Mounts = [{
      #       Type = "9p";
      #       Tag = "vol0";
      #       Source = conf.user.home;
      #       Target = conf.user.home;
      #       ReadOnly = false;
      #     }];
      #     IdentityPath = "${conf.user.home}/.ssh/${cfg.name}";
      #     IgnitionFilePath =
      #       "${conf.user.home}/.config/containers/podman/machine/qemu/${cfg.name}.ign";
      #     ImageStream = "testing";
      #     ImagePath =
      #       "${conf.user.home}/.local/share/containers/podman/machine/qemu/${cfg.name}_fedora-coreos-36.20220421.dev.0-qemu.aarch64.qcow2";
      #     Memory = cfg.memory;
      #     DiskSize = cfg.diskSize;
      #     Name = "${cfg.name}";
      #     Port = 57056;
      #     QMPMonitor = {
      #       Address =
      #         "${config.xdg.dataHome}/containers/podman/machine/${cfg.name}/qmp.sock";
      #       Network = "unix";
      #       Timeout = 2000000000;
      #     };
      #     RemoteUsername = "core";
      #     Rootful = false;
      #     UID = conf.user.uid;
      #   };
      # };
    };
  };
}
