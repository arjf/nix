{
  config,
  lib,
  pkgs,
  ...
}:
{
  # VMs with libvirt
  virtualisation.libvirtd = {
    enable = lib.mkDefault true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  virtualisation.libvirtd.qemu.vhostUserPackages = [ pkgs.virtiofsd ];

  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 jo qemu-libvirtd -"
  ];

  users.users.jo.extraGroups = [ "libvirtd" ];

  environment.systemPackages = with pkgs; [
    virtiofsd
    virtio-win
    virt-viewer
    virt-manager
    qemu
    skopeo
    guestfs-tools
    looking-glass-client
    quickemu
  ];
}
