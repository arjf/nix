{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot.kernelParams = [
    "amdgpu.ppfeaturemask=0xffffffff"
    "amdgpu.gpu_recovery=1"
  ];

  hardware.amdgpu.initrd.enable = true;

  hardware.graphics.extraPackages = with pkgs; [
    libva-vdpau-driver
    rocmPackages.clr.icd
  ];

  environment.variables = {
    VDPAU_DRIVER = "radeonsi";
    LIBVA_DRIVER_NAME = "radeonsi";
    AMD_VULKAN_ICD = "RADV";
  };

  environment.systemPackages = with pkgs; [
    radeontop
    nvtopPackages.amd
  ];
}
