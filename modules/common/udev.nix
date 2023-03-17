{ config, lib, pkgs, ... }:

{
  services.udev.extraRules = ''
    SUBSYSTEM=="block", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="0003", ACTION=="add", SYMLINK+="rp2040upl%n"

    SUBSYSTEM=="usb", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="6018", GROUP="users", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", GROUP="users", MODE="0666"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="c251", ATTRS{idProduct}=="f001", GROUP="users", MODE="0660"

    SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic GDB Server", SYMLINK+="ttyBMPGDB"
    SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic UART Port", SYMLINK+="ttyBMPUart"


    # rules for OpenHantek6022 (DSO program) as well as Hankek6022API (python tools)
    # Hantek DSO-6022BE, without FW, with FW
    SUBSYSTEM=="usb", ACTION=="add", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="04b4", ATTRS{idProduct}=="6022", TAG+="uaccess", TAG+="udev-acl", GROUP="plugdev"
    SUBSYSTEM=="usb", ACTION=="add", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="04b5", ATTRS{idProduct}=="6022", TAG+="uaccess", TAG+="udev-acl", GROUP="plugdev"

    # Hantek DSO-6022BL, without FW, with FW
    SUBSYSTEM=="usb", ACTION=="add", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="04b4", ATTRS{idProduct}=="602a", TAG+="uaccess", TAG+="udev-acl", GROUP="plugdev"
    SUBSYSTEM=="usb", ACTION=="add", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="04b5", ATTRS{idProduct}=="602a", TAG+="uaccess", TAG+="udev-acl", GROUP="plugdev"

    # Voltcraft DSO-2020, without FW (becomes DSO-6022BE when FW is uploaded)
    SUBSYSTEM=="usb", ACTION=="add", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="04b4", ATTRS{idProduct}=="2020", TAG+="uaccess", TAG+="udev-acl", GROUP="plugdev"

    # BUUDAI DDS120, without FW, with FW
    SUBSYSTEM=="usb", ACTION=="add", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="8102", ATTRS{idProduct}=="8102", TAG+="uaccess", TAG+="udev-acl", GROUP="plugdev"
    SUBSYSTEM=="usb", ACTION=="add", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="04b5", ATTRS{idProduct}=="0120", TAG+="uaccess", TAG+="udev-acl", GROUP="plugdev"

    # Hantek DSO-6021, without FW, with FW
    SUBSYSTEM=="usb", ACTION=="add", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="04b4", ATTRS{idProduct}=="6021", TAG+="uaccess", TAG+="udev-acl", GROUP="plugdev"
    SUBSYSTEM=="usb", ACTION=="add", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="04b5", ATTRS{idProduct}=="6021", TAG+="uaccess", TAG+="udev-acl", GROUP="plugdev"


    # Proffieboard
    ATTRS{idVendor}=="1209", ATTRS{idProduct}=="6668", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="1209", ATTRS{idProduct}=="6668", ENV{MTP_NO_PROBE}="1"
    ATTRS{idVendor}=="1209", ATTRS{idProduct}=="6668", ENV{UDISKS_AUTO}="0"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="6668", MODE:="0666"
    KERNEL=="ttyACM*", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="6668", MODE:="0666"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666"
    ATTRS{idVendor}=="1209", ATTRS{idProduct}=="6666", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="1209", ATTRS{idProduct}=="6666", ENV{MTP_NO_PROBE}="1"
    ATTRS{idVendor}=="1209", ATTRS{idProduct}=="6666", ENV{UDISKS_AUTO}="0"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="6666", MODE:="0666"
    KERNEL=="ttyACM*", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="6666", MODE:="0666"
    ATTRS{idVendor}=="1209", ATTRS{idProduct}=="6667", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="1209", ATTRS{idProduct}=="6667", ENV{MTP_NO_PROBE}="1"
    ATTRS{idVendor}=="1209", ATTRS{idProduct}=="6667", ENV{UDISKS_AUTO}="0"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="6667", MODE:="0666"
    KERNEL=="ttyACM*", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="6667", MODE:="0666"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666"
    ATTRS{idVendor}=="1209", ATTRS{idProduct}=="6669", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="1209", ATTRS{idProduct}=="6669", ENV{MTP_NO_PROBE}="1"
    ATTRS{idVendor}=="1209", ATTRS{idProduct}=="6669", ENV{UDISKS_AUTO}="0"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="6669", MODE:="0666"
    KERNEL=="ttyACM*", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="6669", MODE:="0666"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666"
    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", ENV{MTP_NO_PROBE}="1"
    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", ENV{UDISKS_AUTO}="0"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", MODE:="0666"
    KERNEL=="ttyACM*", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", MODE:="0666"

    # Wacom tablet
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="056a", ATTRS{idProduct}=="0303", GROUP="input", MODE="0660"
  '';

}
