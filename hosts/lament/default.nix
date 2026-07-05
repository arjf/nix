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
    ./luks.nix
    ./filesystems.nix
    ../../modules/core/lvm.nix
    ../../modules/core/luks.nix
    ../../modules/core/btrfs.nix
    ../../modules/hardware/msi.nix
    ../../modules/hardware/i915.nix
    ../../modules/hardware/nvidia.nix
    ../../modules/services/cuda.nix
    # ../../modules/services/throttled.nix
    ../../overrides/bose-soundbar.nix
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
  system = {
    host = lib.mkForce hostname;
    stateVersion = lib.mkForce "25.11";
  };

  # Use NVIDIA GPU
  services.xserver.videoDrivers = [
    "nvidia"
  ];
}
