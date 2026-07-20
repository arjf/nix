{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot.kernelParams = [
    "split_lock_detect=off"
    "panic=10"
    "oops=panic"
    "amd_pstate=passive"
    "amd_pstate.shared_mem=1"
  ];
}
