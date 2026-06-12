{
  config,
  lib,
  pkgs,
  ...
}:
{
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 4096;
      cores = 4;
      graphics = true;
    };
    hardware.nvidia-container-toolkit.enable = lib.mkForce false;
    users.users.jo.password = "test";
    users.mutableUsers = false;
  };
}
