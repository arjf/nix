{
  stdenv,
  lib,
  fetchFromGitHub,
  kernelModuleMakeFlags,
  kernel,
}:
stdenv.mkDerivation {
  pname = "msi-ec-kmods";
  version = "0-unstable-2025-ffb36db";

  src = fetchFromGitHub {
    owner = "BeardOverflow";
    repo = "msi-ec";
    rev = "ffb36db8ae28a520dd570f56735de49845106e0e";
    sha256 = "sha256-MdFue0buh/8yE4lIdEbLa11pkwfRFvQ6VIU9mZM3hDo=";
  };

  hardeningDisable = [ "pic" ];

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  installTargets = [ "modules_install" ];

  enableParallelBuilding = true;

  postPatch = ''
    sed -i 's|/lib/modules/[^/]*/build|$(KERNELDIR)|g' Makefile
    echo -e '\nmodules_install:\n\t$(MAKE) -C $(KERNELDIR) M=$(CURDIR) modules_install' >> Makefile
  '';

  meta = {
    description = "Kernel modules for MSI Embedded controller";
    homepage = "https://github.com/BeardOverflow/msi-ec";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
