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
    ../../overrides/bose-soundbar.nix
  ];

  system = {
    host = lib.mkForce hostname;
    stateVersion = lib.mkForce "25.11";
  };

  # Use NVIDIA GPU
  services.xserver.videoDrivers = [
    "nvidia"
  ];
}
