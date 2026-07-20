{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.lvm.enable = true;

  # systemd-initrd handles LVM natively; only set legacy initrd path as fallback
  boot.initrd.services.lvm.enable = lib.mkIf (!config.boot.initrd.systemd.enable) true;

  boot.initrd.kernelModules = [
    "dm-snapshot"
    "dm-raid"
    "dm-cache-default"
  ];
}
