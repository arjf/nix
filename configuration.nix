{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.default
    inputs.nur.modules.nixos.default
    ./modules/default.nix
  ];

  system.stateVersion = lib.mkDefault "26.05";
}
