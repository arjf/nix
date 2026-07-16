{
  config,
  lib,
  pkgs,
  ...
}:
{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/6ae839fc-7a68-4e53-87cd-1d4dc649c67a";
    fsType = "btrfs";
    options = [
      "subvol=@"
      "compress=none"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/6ae839fc-7a68-4e53-87cd-1d4dc649c67a";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "compress=none"
    ];
  };

  fileSystems."/efi" = {
    device = "/dev/disk/by-uuid/B15C-8EC2";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/DCC6FCF8C6FCD3AC";
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

  swapDevices = [
    { device = "/dev/disk/by-uuid/b5a2c261-fb68-4643-8853-7de53398f7ee"; }
  ];

}
