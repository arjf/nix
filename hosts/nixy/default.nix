{
  config,
  lib,
  pkgs,
  hostname,
  ...
}:
{
  imports = [
    ./hardware.nix
    ./filesystems.nix
    ../../modules/core/btrfs.nix
    ../../modules/core/secure-boot.nix
    ../../modules/core/snapshots.nix
  ];

  system = {
    host = lib.mkForce hostname;
    stateVersion = lib.mkForce "25.11";
  };

}
