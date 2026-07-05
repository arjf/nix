{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    max-jobs = lib.mkDefault 0;
    cores = lib.mkDefault 0;

    auto-optimise-store = lib.mkDefault true;

    substituters = lib.mkBefore [
      "https://niri-flake.cachix.org"
      "https://nix-community.cachix.org"
    ];

    trusted-public-keys = [
      "niri-flake.cachix.org-1:xJ7qBqNSFob2wUiCQkkCCusMhMG+UiMIGa5E3Cgvd1c="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "daily";
    options = lib.mkDefault "--delete-older-than 5d";
  };

  imports = [
    inputs.nix-index-database.nixosModules.nix-index
  ];

  programs.nix-index-database.comma.enable = true;
}
