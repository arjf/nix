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

  sops.secrets.smb-password = { };

  services.smb = {
    enable = true;
    passwordFile = config.sops.secrets.smb-password.path;
  };

  services.cockpit.enable = true;

  system = {
    host = lib.mkForce hostname;
    stateVersion = lib.mkForce "25.11";
  };

}
