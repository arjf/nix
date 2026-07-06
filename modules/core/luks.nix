{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot.initrd.systemd.enable = true;

  boot.initrd.luks.devices."cryptroot" = lib.mkDefault {
    device = "/dev/disk/by-uuid/CHANGEME";
    autoUnlock.tpm2.enable = true;
  };

  environment.systemPackages = with pkgs; [
    cryptsetup
  ];
}
