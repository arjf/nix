{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./boot/default.nix
    ./host.nix
    ./networking.nix
    ./locale.nix
    ./users.nix
    ./nix.nix
    ./vm-variant.nix
    ./shell.nix
  ];
}
