{ ... }:

{
  programs.zellij = {
    enable = true;
    enableFishIntegration = false;
    settings = {
      default_shell = "fish";
      pane_frames = false;
      simplified_ui = true;
    };
  };
}
