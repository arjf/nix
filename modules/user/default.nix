{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./zsh.nix
    ./discord.nix
    ./neovim.nix
    ./niri.nix
    ./wayland-tooling.nix
  ];
}
