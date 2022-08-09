self: super:

{
  stlink-tool = super.callPackage ./stlink-tool {};
  ansible-run = super.callPackage ./ansible-run {};
  bootstrap = super.callPackage ./bootstrap {};
  kubectx = super.callPackage ./kubectx {};

  libnpupnp = super.callPackage ./libnpupnp {};

  obs-midi = super.callPackage ./obs-midi {};
}
