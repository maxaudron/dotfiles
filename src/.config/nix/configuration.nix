{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ pkgs.go
      pkgs.go-md2man
      pkgs.vim
      pkgs.exa
      pkgs.mpv
      pkgs.fzf
      pkgs.qemu
      pkgs.htop
      pkgs.inxi
      pkgs.stow
      pkgs.pass
      pkgs.gnupg
      pkgs.yabai
      pkgs.gvproxy
      pkgs.emacsUnstable
      # pkgs.pulseaudio
    ];

  fonts = {
    enableFontDir = true;
    fonts = 
      [ pkgs.ibm-plex
        pkgs.nerdfonts
        pkgs.emacs-all-the-icons-fonts
      ];
  };

  services.emacs.package = pkgs.emacsUnstable;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
    # (final: prev: {
    #   useSystemd = false;
    #   bluetoothSupport = false;
    #   pulseaudio = prev.pulseaudio.overrideDerivation (old: {
    #     configureFlags = old.configureFlags ++ [
    #       "--with-mac-sysroot=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk"
    #       "--with-mac-version-min=12.1"
    #     ];
    #     NIX_CFLAGS_COMPILE = "-isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk " + (old.NIX_CFLAGS_COMPILE or "");
    #   });
    # })
  ];

  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;

  environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

  # services.emacs.enable = true;

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/.config/nix/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  # programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
