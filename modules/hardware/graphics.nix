{
  config,
  lib,
  pkgs,
  ...
}:
{
  hardware.graphics = {
    enable = lib.mkDefault true;
    enable32Bit = lib.mkDefault true;
  };

  environment.systemPackages = with pkgs; [
    libva-utils
    vdpauinfo
    vulkan-tools
    mesa-demos
  ];
}
