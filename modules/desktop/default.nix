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
  ];

  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];
}
