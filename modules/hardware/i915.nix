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
    # "i915.force_probe=9a68"    # unnecessary on kernel 7.1, TigerLake is auto-detected
    # "i915.enable_psr=0"        # Panel Self-Refresh off (was to avoid flicker)
    # "i915.enable_guc=3"        # GuC submission + SLPC
    # "i915.reset=3"             # engine-level GPU reset
    # "i915.enable_fbc=1"        # Framebuffer Compression
    "intel_iommu=igfx_off"
  ];

  hardware.intel-gpu-tools.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-vaapi-driver
    intel-compute-runtime
    openvino
  ];

}
