{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.pathAdditions = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "PATH entries to inject into user shell initExtra";
  };
}
