{
  config,
  lib,
  pkgs,
  ...
}:
{
  # JetBrains IDEs
  environment.systemPackages = with pkgs; [
    jetbrains.idea
    jetbrains.pycharm
    jetbrains.clion
    jetbrains.goland
    jetbrains.webstorm
    jetbrains.rider
    jetbrains.datagrip
    jetbrains.rust-rover
  ];
}
