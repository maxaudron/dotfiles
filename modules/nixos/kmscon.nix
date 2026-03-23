{ pkgs, secrets, ... }:

{
  services.kmscon = {
    enable = true;
    hwRender = true;
    useXkbConfig = true;
    extraConfig = ''
      font-dpi=160
      font-size=6

      palette=custom
      palette-foreground=186, 194, 222
      palette-background=24, 24, 37

      palette-black=69, 71, 90
      palette-dark-grey=88, 91, 112
      palette-light-grey=166, 173, 200

      palette-red=243, 139, 168
      palette-light-red=243, 119, 153

      palette-green=166, 227, 161
      palette-light-green=137, 216, 139

      palette-yellow=249, 226, 175
      palette-light-yellow=235, 211, 145

      palette-blue=137, 180, 250
      palette-light-blue=116, 168, 252

      palette-magenta=245, 194, 231
      palette-light-magenta=242, 174, 222

      palette-cyan=148, 226, 213
      palette-light-cyan=107, 215, 202

      palette-white=186, 194, 222
    '';
  };
}
