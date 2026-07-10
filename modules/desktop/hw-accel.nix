{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    libva-utils # vainfo

    vdpauinfo # vdpauinfo

    mesa-glinfo # glxinfo, glxgears
    egl-utils # eglinfo, eglgears_wayland
    mesa-utils

    vulkan-tools # vulkaninfo
    vulkan-validation-layers

  ];
}
