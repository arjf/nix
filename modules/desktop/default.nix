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

  services.printing.enable = lib.mkDefault true;

  services.gvfs.enable = lib.mkDefault true;
  services.udisks2.enable = lib.mkDefault true;

  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];
}
