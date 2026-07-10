{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./sddm.nix
    ./plasma.nix
    ./hw-accel.nix
  ];

  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];
}
