{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot.kernelModules = [
    "kvm-intel"
  ];

  boot.extraModprobeConfig = ''
    options kvm_intel nested=1 emulate_invalid_guest_state=0
  '';
}
