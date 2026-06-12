{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot.kernelModules = [
    "acpi_ec"
    "ec_sys"
  ];

  boot.extraModprobeConfig = ''
    options acpi_ec write_support=1
  '';
}
