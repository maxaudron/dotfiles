self: super:

{
  stlink-tool = super.callPackage ./stlink-tool {};
  ansible-run = super.callPackage ./ansible-run {};
  bootstrap = super.callPackage ./bootstrap {};
  kubectx = super.callPackage ./kubectx {};
  kubectl-ssh = super.callPackage ./kubectl-ssh {};

  libnpupnp = super.callPackage ./libnpupnp {};

  obs-midi = super.callPackage ./obs-midi {};
  diskimage-builder = super.callPackage ./diskimage-builder {};
  kube-review = super.callPackage ./kube-review {};
  sddm-theme-chili = super.callPackage ./sddm-theme-chili {};
}
