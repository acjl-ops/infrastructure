{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  config = mkIf (builtins.elem "input" config.sanix.hardware) {
      # Keychron firmware is stupid and exports the keyboard as an Apple keyboard,
      # even on Windows/Android mode.
      boot.kernelModules = [ "hid-apple" ];
      # add it to initrd too
      boot.initrd.kernelModules = [ "hid-apple" ];

      boot.kernelParams = [
        # Keychron firmware is very stupid and requires this to be set
        "hid_apple.fnmode=2" "hid_apple.swap_opt_cmd=1"
      ];
  };
}
