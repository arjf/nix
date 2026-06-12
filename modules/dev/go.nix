{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Go development
  environment.systemPackages = with pkgs; [
    go
    gotools
    gopls
    golangci-lint
    delve
  ];
}
