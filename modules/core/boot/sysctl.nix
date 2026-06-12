{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot.kernel.sysctl = {
    "vm.dirty_bytes" = 268435456;
    "vm.dirty_background_bytes" = 134217728;
    "kernel.split_lock_mitigate" = 0;
    "vm.transparent_hugepage" = "madvise";
  };
}
