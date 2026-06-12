{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./params.nix
    ./sysctl.nix
  ];

  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  # Emulated architectures
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "riscv64-linux"
  ];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.blacklistedKernelModules = [ ];
}
