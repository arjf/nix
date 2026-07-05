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

  nixpkgs.overlays = [
    (final: prev: {
      # pnpm_10_29_2 is pinned for electron-builder compat but has known CVEs.
      # pnpm_10 (10.34.0) has all the same fixes and is not insecure.
      pnpm_10_29_2 = prev.pnpm_10;

      # micromamba copies the bash wrapper (bin/mamba) instead of the actual
      # ELF binary. When the wrapper execs .mamba-wrapped, that binary reads
      # /proc/self/exe and refuses to run because its filename isn't "mamba"
      # or "micromamba". Copy the ELF binary directly.
      # micromamba = prev.micromamba.overrideAttrs (old: {
      #   installPhase = ''
      #     mkdir -p $out/bin
      #     cp ${prev.mamba-cpp}/bin/.mamba-wrapped $out/bin/micromamba
      #   '';
      # });
    })
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
