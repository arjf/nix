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
    ./niri.nix
  ];

  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];
}
