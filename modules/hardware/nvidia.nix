{
  config,
  lib,
  pkgs,
  ...
}:
{

  boot.blacklistedKernelModules = [ "nouveau" ];

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

  #boot.kernel.sysctl = {
  #  "vm.min_free_kbytes" = 262144; # 256MB buffer
  #  "vm.watermark_boost_factor" = 15000;
  #};

  # hardware.nvidia-container-toolkit.enable = true;

  hardware.nvidia = {
    # enabled = true;
    dynamicBoost.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    powerManagement.kernelSuspendNotifier = false;
    open = false;
    nvidiaSettings = true;
    prime = {
      reverseSync.enable = true;
      offload.enable = false;
      intelBusId = lib.mkDefault "PCI:0@0:2:0";
      nvidiaBusId = lib.mkDefault "PCI:1@0:0:0";
    };
    videoAcceleration = true;
    nvidiaPersistenced = false;
  };

  hardware.graphics.extraPackages = with pkgs; [
    nvidia-vaapi-driver
  ];
}
