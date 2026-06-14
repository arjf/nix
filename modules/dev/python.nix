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

  my.pathAdditions = [ "$HOME/.pixi/bin" ];
}
