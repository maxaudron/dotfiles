{ config, lib, builtins, pkgs, ... }:

let conf = import ../config { inherit lib; };
in
{
  programs.gpg = {
    enable = true;

    mutableKeys = false;
    mutableTrust = true;

    publicKeys = [
      {
        source = builtins.fetchurl {
          url =
            "https://keys.openpgp.org/vks/v1/by-fingerprint/81040D00839B1C5903D07D067828577F894C55C0";
          sha256 = "0jya2ak2vgqvz8zpafmjvx714s01pxwgn18q7bkvg7bvc9vj4hnm";
        };
        trust = 5;
      }

      {
        source = builtins.fetchurl {
          url =
            "https://keys.openpgp.org/vks/v1/by-fingerprint/4FB3D12CC95D9055B2D507168E43B2378F0BD40B";
          sha256 = "0c6vl684a92i42fcj4jbrngfgd98wzvlgljrnq2y29j9462w1sjn";
        };
        trust = 4;
      }
    ];

    settings = {
      # Use AES256, 192, or 128 as cipher
      personal-cipher-preferences = "AES256 AES192 AES";
      # Use SHA512, 384, or 256 as digest
      personal-digest-preferences = "SHA512 SHA384 SHA256"; # Use ZLIB, BZIP2, ZIP, or no compression
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      # Default preferences for new keys
      default-preference-list =
        "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
      # SHA512 as digest to sign keys
      cert-digest-algo = "SHA512";
      # SHA512 as digest for symmetric ops
      s2k-digest-algo = "SHA512";
      # AES256 as cipher for symmetric ops
      s2k-cipher-algo = "AES256";
      # UTF-8 support for compatibility
      charset = "utf-8";
      # Show Unix timestamps
      fixed-list-mode = true;
      # No comments in signature
      no-comments = true;
      # No version in signature
      no-emit-version = true;
      # Long hexidecimal key format
      keyid-format = "0xlong";
      # Display UID validity
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";
      # Display all keys and their fingerprints
      with-fingerprint = true;
      # Display key origins and updates
      #with-key-origin
      # Cross-certify subkeys are present and valid
      require-cross-certification = true;
      # Disable caching of passphrase for symmetrical ops
      no-symkey-cache = true;
      # Enable smartcard
      use-agent = true;
      # Set keyserver
      keyserver = "hkps://keys.openpgp.org";
    };

    scdaemonSettings = { disable-ccid = true; };
  };

  services.gpg-agent = lib.mkIf (conf.os.type == "linux") ({
    enable = true;
    enableSshSupport = true;
  });
}
