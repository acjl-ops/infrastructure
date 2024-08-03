{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  # dependency scripts
  home.file."${config.xdg.configHome}/hypr/scripts/focusworkspace.sh".source =
    ./../../../../dots/wm-hyprland/focusworkspace.sh;

  wayland.windowManager.hyprland.extraConfig = lib.fileContents ./../../../../dots/wm-hyprland/hyprland.conf;

  home.packages = with pkgs;
    [
      wofi
      kitty
      nautilus
    ];
}
