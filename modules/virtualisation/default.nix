{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./docker.nix
    ./podman.nix
    ./virt.nix
    ./waydroid.nix
  ];
}
