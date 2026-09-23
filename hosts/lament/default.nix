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
    ../../modules/hardware/openvino.nix
    ../../modules/services/cuda.nix
    ../../modules/services/throttled.nix
    ../../overrides/bose-soundbar.nix
    ../../modules/core/secure-boot.nix
    ../../modules/core/snapshots.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/ly.nix
    ../../modules/virtualisation/kvm-intel.nix
    ../../modules/desktop/cosmic-greeter.nix
    ../../modules/desktop/cosmic.nix
    ../../modules/desktop/default.nix
  ];

  services.power-profiles-daemon = {
    enable = lib.mkForce false;
  };

  sops.secrets.smb-password = { };

  services.smb = {
    enable = true;
    passwordFile = config.sops.secrets.smb-password.path;
  };

  services.cockpit = {
    enable = true;
    "allowed-origins" = [ "https://${hostname}:9090" ];
  };

  nixpkgs.overlays = [
    (final: prev: {
      # pnpm_10_29_2 is pinned for electron-builder compat but has known CVEs.
      # pnpm_10 (10.34.0) has all the same fixes and is not insecure.
      pnpm_10_29_2 = prev.pnpm_10;
    })
  ];

  system = {
    host = lib.mkForce hostname;
    stateVersion = lib.mkForce "25.11";
  };

  # Use NVIDIA GPU
  services.xserver.videoDrivers = lib.mkForce [
    "nvidia"
    "modesetting"
  ];

  boot.kernel.sysctl = {
    "kernel.perf_event_max_sample_rate" = 25000;
    "kernel.perf_cpu_time_max_percent" = 10;
  };

}
