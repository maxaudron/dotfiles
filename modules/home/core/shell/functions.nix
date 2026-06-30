{ lib, ... }:

let
  files = lib.mapAttrsToList (name: type: name) (builtins.readDir ./functions);

in
{
  programs.zsh.plugins = map (func: {
    name = "functions";
    file = func;
    src = ./functions;
  }) files;

  programs.fish.functions = {
    pastor = {
      description = "uploads a file to c-v.sh";
      argumentNames = "file";
      body = ''
        curl --progress-bar \
          -H "Authorization: Bearer $(pass show general/c-v.sh | head -n1)" \
          -F "c=@$file" \
          "https://c-v.sh"
      '';
    };

    screenshot = ''grim -g "$(slurp)" - | pastor - | wl-copy'';

    nix-prefetch-sri = {
      description = "nix-prefetch a url and convert it to sri";
      argumentNames = "url";
      body = ''nix-prefetch-url "$1" | xargs nix hash to-sri --type sha256'';
    };

    password = ''LC_CTYPE=C tr -dc A-Za-z0-9 </dev/urandom | head -c $1 ; echo ""'';

    tmpdir = {
      description = "create and mount a tmpfs to specified location";
      argumentNames = [
        "dir"
        "size"
      ];
      body = ''
        mkdir -p $dir
        set -q size[1]; or set size "4G"
        sudo mount -t tmpfs -o size=$size tmpfs $dir
        sudo chown $(id -u):$(id -g) $dir
      '';
    };
  };
}
