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
    uv
  ];

  my.pathAdditions = [ "$HOME/.pixi/bin" ];
}
