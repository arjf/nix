{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Realtek RTS5129 USB card reader – rtsx_usb is the parent USB transport
  # driver that rtsx_usb_sdmmc depends on. The generated hardware.nix from
  # nixos-generate-config only lists rtsx_usb_sdmmc.
  boot.kernelModules = [
    "rtsx_usb"
    "rtsx_usb_sdmmc"
  ];
}
