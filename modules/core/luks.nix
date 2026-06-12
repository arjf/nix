{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot.initrd.luks.devices."cryptroot" = lib.mkDefault {
    device = "/dev/disk/by-uuid/CHANGEME";
  };

  environment.systemPackages = with pkgs; [
    cryptsetup
  ];
}
