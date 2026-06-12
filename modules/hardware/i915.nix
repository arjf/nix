{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Intel i915 iGPU
  boot.kernelModules = [ "i915" ];

  boot.kernelParams = [
    "i915.force_probe=9a68"
    "i915.enable_psr=0"
    "i915.enable_guc=3"
    "i915.reset=3"
    "i915.enable_fbc=1"
    "intel_iommu=igfx_off"
  ];

  boot.blacklistedKernelModules = [ "xe" ];
}
