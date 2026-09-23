{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.extraSpecialArgs = {
    inherit (config) my;
    inherit inputs;
  };

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

      home.file.".npmrc".text = ''
        prefix=${config.home.homeDirectory}/.npm-packages
      '';

      services.kbfs.enable = true;
      services.ssh-agent.enable = true;
    };
}
