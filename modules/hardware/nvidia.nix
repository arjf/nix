{
  config,
  lib,
  pkgs,
  ...
}:
{

  boot.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  boot.kernelParams = [
    "nvidia.NVreg_TemporaryFilePath=/var/tmp"
  ];

  boot.extraModprobeConfig = ''
    options nvidia_drm fbdev=1
    options nvidia NVreg_TemporaryFilePath=/var/tmp
  '';

  hardware.nvidia-container-toolkit.enable = true;

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    prime = {
      sync.enable = false;
      offload.enable = true;
      intelBusId = lib.mkDefault "PCI:0@0:2:0";
      nvidiaBusId = lib.mkDefault "PCI:1@0:0:0";
      offload.enableOffloadCmd = true;
    };
  };
}
