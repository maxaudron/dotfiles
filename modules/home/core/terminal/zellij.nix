{ ... }:

{
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      default_shell = "fish";
      pane_frames = false;
      simplified_ui = true;
    };
  };
}
