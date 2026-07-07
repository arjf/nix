{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.lvm.enable = true;
  boot.initrd.services.lvm.enable = true;

  boot.initrd.kernelModules = [
    "dm-snapshot"
    "dm-raid"
    "dm-cache-default"
  ];
}
