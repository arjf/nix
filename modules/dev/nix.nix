{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Nix development
  environment.systemPackages = with pkgs; [
    nixd
    nil
  ];
}
