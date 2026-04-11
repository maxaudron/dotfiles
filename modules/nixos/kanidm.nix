{ pkgs, ... }:

{
  services.kanidm = {
    package = pkgs.kanidm_1_8;
    enableClient = true;
    clientSettings.uri = "https://id.vapor.systems";
  };
}
