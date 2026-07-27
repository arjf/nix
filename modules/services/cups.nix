{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:{
  services.printing = {
    enable = lib.mkDefault true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
      hplipWithPlugin
    ];
  };
  services.ipp-usb.enable = true;

}
