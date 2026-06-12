{
  config,
  lib,
  pkgs,
  ...
}:
{
  # MSI laptop hardware
  boot.kernelModules = [ "msi-ec" ];

  # This is a hacky way of running a newer version of msi-ec which supports my fw
  boot.extraModulePackages = [
    (pkgs.callPackage ../derivations/msi-ec.nix {
      kernel = config.boot.kernelPackages.kernel;
    })
  ];

  environment.systemPackages = with pkgs; [
    mcontrolcenter
  ];
}
