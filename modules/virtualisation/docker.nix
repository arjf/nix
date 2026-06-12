{
  config,
  lib,
  pkgs,
  ...
}:
{
  virtualisation.docker.enable = lib.mkDefault true;
  virtualisation.docker.daemon.settings.features.cdi = lib.mkDefault true;

  users.users.jo.extraGroups = [ "docker" ];

  environment.systemPackages = with pkgs; [
    docker
  ];
}
