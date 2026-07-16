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
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/ly.nix
  ];

  services.displayManager.sddm.enable = lib.mkForce false;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [ drkonqi ];
  systemd.services."drkonqi-coredump-processor@" = {
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

      # micromamba nixpkg issue
      micromamba = prev.micromamba.overrideAttrs (old: {
        installPhase = ''
          mkdir -p $out/bin
          cp ${prev.mamba-cpp}/bin/.mamba-wrapped $out/bin/micromamba
        '';
      });
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

}
