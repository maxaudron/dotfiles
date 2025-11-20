self: super:

{
  ansible-run = super.callPackage ./ansible-run {};
  bootstrap = super.callPackage ./bootstrap {};

  kubectx = super.callPackage ./kubectx {};
  kubectl-ssh = super.callPackage ./kubectl-ssh {};
  kubectl-netshoot = super.callPackage ./kubectl-netshoot {};

  teamspeak3 = super.libsForQt5.callPackage ./teamspeak3 {};
  
  # quasselClient = super.qt6.callPackage ./quassel {};
  # quasselCore = super.qt6.callPackage ./quassel { client = false; enableDaemon = true; };

  spleen = super.callPackage ./spleen {};
}
