{ pkgs, ... }:

let
  ifname = "wg0";
in
{
  environment.systemPackages = [ pkgs.wireguard-tools ];
  systemd.network = {
    enable = true;

    config.routeTables = {
      vpn = 1000;
    };

    netdevs."50-${ifname}" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "${ifname}";
      };

      wireguardConfig = {
        PrivateKeyFile = "/etc/wireguard/privatekey";
        FirewallMark = 1001;
      };

      wireguardPeers = [
        {
          Endpoint = "ettves.vapor.systems:51820";
          PublicKey = "5OTaf4MnSzTcCR10CGSrLFngGa3gdzajbqUKkRF+WlY=";
          AllowedIPs = [
            # Wireguard peers
            "10.10.0.0/24"
            "2a0f:9400:8020:beef::/64"
            "fd15:3d8c:d429:beef::/64"
            "0.0.0.0/0"
            "::/0"
          ];
          RouteTable = "off";
        }
        {
          Endpoint = "phaenn.vapor.systems:51820";
          PublicKey = "GmUvA3L8M2+N59my6MeoGwDD8puLOO5/Rbe29WtduBI=";
          AllowedIPs = [
            # Wireguard peers
            "10.10.0.2/32"
            "2a0f:9400:8020:beef::2/128"
            "fd15:3d8c:d429:beef::2/128"
            "0.0.0.0/0"
            "::/0"
          ];
          RouteTable = "off";
        }
      ];
    };

    networks =
      let
        address = [
          "10.10.0.10/24"
          "2a0f:9400:8020:beef::10/128"
          "fd15:3d8c:d429:beef::10/128"
        ];
      in
      {
        # "50-${ifname}" = {
        #   matchConfig.Name = ifname;
        #   inherit address;
        # };

        "50-${ifname}-split" = {
          matchConfig.Name = ifname;
          inherit address;

          routes = map (addr: {
            Destination = addr;
            Scope = "link";
          }) address;
        };

        # "50-${ifname}-full" = {
        #   matchConfig.Name = ifname;
        #   inherit address;
        #
        #   routingPolicyRules = [
        #     {
        #       Family = "both";
        #       FirewallMark = 1001;
        #       InvertRule = true;
        #       Table = "1000";
        #       Priority = 10;
        #     }
        #     {
        #       To = endpoint;
        #       Priority = 5;
        #     }
        #     {
        #       To = "192.168.144.0/24";
        #       Priority = 9;
        #     }
        #   ];
        #
        #   routes = [
        #     {
        #       Destination = "0.0.0.0/0";
        #       PreferredSource = "10.10.0.10";
        #       Table = "1000";
        #     }
        #     {
        #       Destination = "::/0";
        #       PreferredSource = "10.10.0.10";
        #       Table = "1000";
        #     }
        #   ];
        # };
      };
  };

  # environment.systemPackages = [
  #   (pkgs.writeScriptBin "wg-mode-split" ''
  #     #!/usr/bin/env bash
  #     sudo rm -f /etc/systemd/network/30-wg0-active.network
  #     sudo cp /etc/systemd/network/30-wg0-split.network /etc/systemd/network/30-wg0-active.network
  #     sudo networkctl reload wg0
  #     echo "Switched to split tunnel mode"
  #   '')
  #   (pkgs.writeScriptBin "wg-mode-full" ''
  #     #!/usr/bin/env bash
  #     sudo rm -f /etc/systemd/network/30-wg0-active.network
  #     sudo cp /etc/systemd/network/30-wg0-full.network /etc/systemd/network/30-wg0-active.network
  #     sudo networkctl reload wg0
  #     echo "Switched to full tunnel mode"
  #   '')
  # ];
}
