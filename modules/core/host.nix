{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.system.host = lib.mkOption {
    type = lib.types.str;
    default = "default";
    description = "Host identifier. Set this in hosts/<name>/default.nix.";
  };

  config = {
    # Define your hostname.
    networking.hostName = config.system.host;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    # Default tmpfs root - hosts override with mkForce.
    fileSystems."/" = lib.mkDefault {
      device = "none";
      fsType = "tmpfs";
    };
  };
}
