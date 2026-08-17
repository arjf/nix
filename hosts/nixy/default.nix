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
    ../../modules/hardware/amdgpu.nix
    ../../modules/hardware/card-reader.nix
    ../../modules/services/tuned.nix
    ../../modules/services/powertop.nix
    ../../modules/core/btrfs.nix
    ../../modules/core/secure-boot.nix
    ../../modules/core/snapshots.nix
    ../../modules/core/zram.nix
    ../../modules/desktop/default.nix
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

  nixpkgs.overlays = [
    (final: prev: {
      # pnpm_10_29_2 is pinned for electron-builder compat but has known CVEs.
      # pnpm_10 (10.34.0) has all the same fixes and is not insecure.
      pnpm_10_29_2 = prev.pnpm_10;
      "electron-40" = final.electron;
    })
  ];

  services.xserver.videoDrivers = lib.mkForce [
    "amdgpu"
    "modesetting"
  ];
  boot.kernelParams = [
    "amd_pstate=passive"
    "amd_pstate.shared_mem=1"
  ];

  system = {
    host = lib.mkForce hostname;
    stateVersion = lib.mkForce "25.11";
  };
}
