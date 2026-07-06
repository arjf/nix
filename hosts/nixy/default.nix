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

  services.cockpit = {
    enable = true;
    "allowed-origins" = [ "https://${hostname}:9090" ];
  };

  boot.loader.efi.efiSysMountPoint = "/efi";

  system = {
    host = lib.mkForce hostname;
    stateVersion = lib.mkForce "25.11";
  };
}
