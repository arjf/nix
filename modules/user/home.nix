{
  config,
  lib,
  pkgs,
  ...
}:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.jo =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      home.stateVersion = "26.05";

      imports = [
        ./default.nix
      ];
    };
}
