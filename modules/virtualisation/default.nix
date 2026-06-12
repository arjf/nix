{ config, lib, pkgs, ... }: {
  imports = [
    ./kvm.nix
    ./docker.nix
    ./podman.nix
    ./virt.nix
    ./waydroid.nix
  ];
}
