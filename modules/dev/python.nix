{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Python development
  environment.systemPackages = with pkgs; [
    pixi
    uv
  ];

  my.pathAdditions = [ "$HOME/.pixi/bin" ];
}
