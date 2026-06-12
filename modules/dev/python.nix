{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Python development
  environment.systemPackages = with pkgs; [
    micromamba
    pixi
  ];
}
