self: super:

{
  ansible-run = super.callPackage ./ansible-run {};
  bootstrap = super.callPackage ./bootstrap {};
  aws-adfs = super.python3Packages.callPackage ./aws-adfs {};

  kubectx = super.callPackage ./kubectx {};
  kubectl-rancher = super.callPackage ./kubectl-rancher {};
  kubectl-ssh = super.callPackage ./kubectl-ssh {};
  kubectl-netshoot = super.callPackage ./kubectl-netshoot {};

  teamspeak3 = super.libsForQt5.callPackage ./teamspeak3 {};
  
  quasselClient = super.qt6.callPackage ./quassel { client = true; withKDE = false; };
  quasselCore = super.qt6.callPackage ./quassel { client = false; enableDaemon = true; };

  spleen = super.callPackage ./spleen {};

  serena = super.python3Packages.callPackage ./serena {};
  brother-ql = super.python314Packages.callPackage ./brother-ql {};

  mcp-hub = super.callPackage ./mcp-hub {};

  llm-usage = super.callPackage ./llm-usage {};

  qmk_redox = super.callPackage ../misc/qmk {};

  firefox-webserial = super.callPackage ./firefox-webserial {};
}

