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

    mesa-demos # glxinfo, glxgears
    # egl-utils # eglinfo, eglgears_wayland
    # mesa-utils

    vulkan-tools # vulkaninfo
  ];
}
