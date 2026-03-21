{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.tgt;

  conf = pkgs.writeText "targets.conf" semanticString;

  # Converts the config option to a string
  semanticString =
    let

      sortedAttrs =
        set:
        sort (
          l: r:
          if l == "extraConfig" then
            false # Always put extraConfig last
          else if isAttrs set.${l} == isAttrs set.${r} then
            l < r
          else
            isAttrs set.${r} # Attrsets should be last, makes for a nice config
          # This last case occurs when any side (but not both) is an attrset
          # The order of these is correct when the attrset is on the right
          # which we're just returning
        ) (attrNames set);

      # Specifies an attrset that encodes the value according to its type
      encode =
        name: value:
        {
          null = [ ];
          bool = [ "${name} ${boolToString value}" ];
          int = [ "${name} ${toString value}" ];

          # extraConfig should be inserted verbatim
          string = [ (if name == "extraConfig" then value else "${name} ${value}") ];

          # Values like `Foo = { bar = { Baz = "baz"; Qux = "qux"; Florps = null; }; };` should be transmed into
          #   <Foo bar>
          #     Baz baz
          #     Qux qux
          #   </Foo>
          set = concatMap (
            subname:
            optionals (value.${subname} != null) (
              [
                "<${name} ${subname}>"
              ]
              ++ map (line: "\t${line}") (toLines value.${subname})
              ++ [
                "</${name}>"
              ]
            )
          ) (filter (v: v != null) (attrNames value));

        }
        .${builtins.typeOf value};

      # One level "above" encode, acts upon a set and uses encode on each name,value pair
      toLines = set: concatMap (name: encode name set.${name}) (sortedAttrs set);

    in
    concatStringsSep "\n" (toLines cfg.settings);

  semanticTypes = with types; rec {
    tgtAtom = nullOr (oneOf [
      int
      bool
      str
    ]);
    tgtAttr = attrsOf (nullOr tgtConf);
    tgtAll = oneOf [
      tgtAtom
      tgtAttr
    ];
    tgtConf = attrsOf (
      tgtAll
      // {
        # Since this is a recursive type and the description by default contains
        # the description of its subtypes, infinite recursion would occur without
        # explicitly breaking this cycle
        description = "tgt values (null, atoms (str, int, bool), list of atoms, or attrsets of tgt values)";
      }
    );
  };
in
{
  options.services.tgt = {
    enable = mkEnableOption "tgt";
    package = mkPackageOption pkgs "tgt" { };
    settings = mkOption {
      type = semanticTypes.tgtConf;
      default = { };
      example = literalExpression ''
        target = {
          "iqn.2020-08.host:volume" = {
            backingStore = "/dev/zvol/volume";
            initiatorAddress = "172.16.0.0";
          };
        };
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.tgt = {
      after = [ "network.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      description = "(i)SCSI target daemon";

      reloadTriggers = [ conf ];

      serviceConfig = {
        Type = "notify";
        TasksMax = "infinity";
        ExecStart = "${cfg.package}/bin/tgtd -D";
        ExecStartPost = [
          "${cfg.package}/bin/tgtadm --op update --mode sys --name State -v offline"
          "${cfg.package}/bin/tgt-admin -e -c /etc/tgt/targets.conf"
          "${cfg.package}/bin/tgtadm --op update --mode sys --name State -v ready"
        ];

        ExecStop = [
          "${cfg.package}/bin/tgtadm --op update --mode sys --name State -v offline"
          "${cfg.package}/bin/tgt-admin --offline ALL"
          "${cfg.package}/bin/tgt-admin --update ALL -c /dev/null -f"
          "${cfg.package}/bin/tgtadm --op delete --mode system"
        ];

        ExecReload = "${cfg.package}/bin/tgt-admin --update ALL -c /etc/tgt/targets.conf";
        Restart = "on-failure";
      };
    };

    environment.etc."tgt/targets.conf".source = conf;
  };
}
