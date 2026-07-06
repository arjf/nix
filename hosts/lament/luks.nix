{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Override the LUKS UUID from modules/core/luks.nix with the real one.
  boot.initrd.luks.devices."cryptroot" = lib.mkForce {
    device = "/dev/disk/by-uuid/41f6c891-cf99-4d0f-9ff8-7438dcaba239";
    autoUnlock.tpm2.enable = true;
  };
}
