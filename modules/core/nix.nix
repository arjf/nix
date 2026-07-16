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

    max-jobs = lib.mkDefault "auto";
    cores = lib.mkDefault 0;

    auto-optimise-store = lib.mkDefault true;

    trusted-users = [
      "root"
      "jo"
    ];

    substituters = lib.mkBefore [
      "https://arjf.cachix.org"
      "https://niri.cachix.org"
      "https://nix-community.cachix.org"
    ];

    trusted-public-keys = [
      "arjf.cachix.org-1:8ddfrqa/mIEdXChzkTViDxiYjUWDlWSZb079yssvmac="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
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
