{ config, lib, pkgs, ... }:

{
  services.pipewire.extraConfig.pipewire = {
    "20-windows" = {
      "context.modules" = [
        { name = "libpipewire-module-vban-recv";
          args = {
            "local.ifname" = "enp5s0";
            "source.ip" = "192.168.144.10";
            "source.port" = 6980;
            "sess.latency.msec" = 30;
            #"node.always-process" = false;
            #"audio.position" = [ FL FR ];
            stream.rules = [
              { matches = [
                  { "sess.name" = "~.*";
                    "sess.media" = "audio";
                    "vban.ip" = "192.168.144.11";
                    "vban.port" = 6980;
                    "audio.channels" = 2;
                    "audio.format" = "S24LE";
                    "audio.rate" = 48000;
                  }
                ];
                actions = {
                  create-stream = {
                    "stream.props" = {
                      "sess.latency.msec" = 30;
                      #target.object = ""
                      #audio.position = [ FL FR ]
                      #media.class = "Audio/Source"
                      "node.name" = "Tiamur";
                    };
                  };
                };
              }
            ];
          };
        }
        { name = "libpipewire-module-vban-send";
          args = {
            "local.ifname" = "enp5s0";
            "source.ip" = "192.168.144.10";
            "destination.ip" = "192.168.144.11";
            "destination.port" = 6980;
            "net.mtu" = 1500;
            "net.ttl" = 1;
            "net.loop" = false;
            "sess.min-ptime" = 2;
            "sess.max-ptime" = 20;
            "sess.name" = "Liduur Mic";
            "sess.media" = "audio";
            "audio.format" = "S24LE";
            "audio.rate" = 48000;
            "audio.channels" = 1;
            "audio.position" = [ "FL" "FR" ];
            "stream.props" = {
              "node.name" = "Tiamur";
              "node.target" = "effect_output.microphone";
            };
          };
        }
      ];
    };
  };
}
