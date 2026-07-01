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
  ];
}
