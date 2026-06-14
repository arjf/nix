{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "daily";
    options = lib.mkDefault "--delete-older-than 5d";
  };

  nix.settings.auto-optimise-store = lib.mkDefault true;

  imports = [
    inputs.nix-index-database.nixosModules.nix-index
  ];

  programs.nix-index-database.comma.enable = true;
}
