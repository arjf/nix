{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.extraSpecialArgs = {
    inherit (config) my;
    inherit inputs;
  };

  home-manager.users.jo =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      home.stateVersion = "26.05";

      imports = [
        ./default.nix
      ];

      home.file.".npmrc".text = ''
        prefix=${config.home.homeDirectory}/.npm-packages
      '';

      home.activation.copyKittyTerminfo = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if [ -f /run/current-system/sw/share/terminfo/x/xterm-kitty ] && \
           [ ! -f ${config.home.homeDirectory}/micromamba/share/terminfo/78/xterm-kitty ]; then
          mkdir -p ${config.home.homeDirectory}/micromamba/share/terminfo/78
          cp "$(readlink -f /run/current-system/sw/share/terminfo/x/xterm-kitty)" \
             ${config.home.homeDirectory}/micromamba/share/terminfo/78/xterm-kitty
        fi
      '';

      services.kbfs.enable = true;
      services.ssh-agent.enable = true;
    };
}
