{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.tpm2.enable = true;

  boot.initrd.luks.devices."cryptroot" = lib.mkDefault {
    device = "/dev/disk/by-uuid/CHANGEME";
  };

  environment.systemPackages = with pkgs; [
    cryptsetup
  ];
}
