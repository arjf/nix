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
    (config.boot.kernelPackages.msi-ec.overrideAttrs (oldAttrs: {
      src = pkgs.fetchFromGitHub {
        owner = "BeardOverflow";
        repo = "msi-ec";
        rev = "ffb36db8ae28a520dd570f56735de49845106e0e";
        sha256 = "sha256-MdFue0buh/8yE4lIdEbLa11pkwfRFvQ6VIU9mZM3hDo=";
      };
      patches = [ ];
      postPatch = ''
        sed -i 's|/lib/modules/[^/]*/build|$(KERNELDIR)|g' Makefile
        echo -e '\nmodules_install:\n\t$(MAKE) -C $(KERNELDIR) M=$(CURDIR) modules_install' >> Makefile
      '';
    }))
  ];

  environment.systemPackages = with pkgs; [
    mcontrolcenter
  ];
}
