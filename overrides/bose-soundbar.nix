{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.pipewire.wireplumber.extraConfig."51-bose-soundbar" = {
    "monitor.bluez.rules" = [
      {
        matches = [
          { "device.name" = "~bluez_card.*C8_7B_23_88_83_D3.*"; }
        ];
        actions = {
          "update-props" = {
            "bluez5.roles" = [ "a2dp_sink" ];
            "bluez5.auto-connect" = [ "a2dp_sink" ];
          };
        };
      }
    ];
  };
}
