{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot.kernelModules = [
    "kvm-amd"
    "kvm-intel"
  ];

  boot.extraModprobeConfig = ''
    options kvm ignore_msrs=1 report_ignored_msrs=0
    options kvm_intel nested=1 emulate_invalid_guest_state=0
    options kvm_amd nested=1
  '';
}
