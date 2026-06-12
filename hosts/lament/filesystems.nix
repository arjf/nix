{
  config,
  lib,
  pkgs,
  ...
}:
{
  fileSystems."/" = {
    device = "/dev/mapper/vg-root";
    fsType = "btrfs";
    options = [ "compress=none" ];
  };

  fileSystems."/home" = {
    device = "/dev/mapper/vg-root";
    fsType = "btrfs";
    options = [ "subvol=home" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/AA6A-89B3";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/mapper/vg-root";
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "compress=none"
    ];
  };

  fileSystems."/mnt/winstor" = {
    device = "/dev/disk/by-uuid/35DAEB472596A2F6";
    fsType = "ntfs3";
    options = [
      "nofail"
      "users"
      "force"
      "fmask=0022"
      "dmask=0022"
      "exec"
      "rw"
      "uid=1000"
    ];
  };

  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/5CDAC3B2DAC3872C";
    fsType = "ntfs3";
    options = [
      "nofail"
      "users"
      "force"
      "fmask=0022"
      "dmask=0022"
      "exec"
      "rw"
      "uid=1000"
    ];
  };

  fileSystems."/mnt/w" = {
    device = "/dev/disk/by-uuid/5C12D51312D4F2CE";
    fsType = "ntfs3";
    options = [
      "uid=1000"
      "nofail"
      "users"
      "force"
      "fmask=0022"
      "dmask=0022"
      "exec"
      "rw"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/b1a3f251-18b2-4c03-ad42-775da7c7e5d2"; }
  ];

}
