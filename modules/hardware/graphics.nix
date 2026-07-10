{
  config,
  lib,
  pkgs,
  ...
}:
{
  hardware.graphics = {
    enable = lib.mkDefault true;
    enable32Bit = lib.mkDefault true;
  };

  environment.systemPackages = with pkgs; [
    openvino
    openvino-genai
    openvino-tokenizers

  ];
}
