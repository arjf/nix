{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot.initrd.lvm.enable = true;

  boot.initrd.kernelModules = [
    "dm-snapshot"
    "dm-raid"
    "dm-cache-default"
  ];

  environment.systemPackages = with pkgs; [
    lvm2
  ];
}
