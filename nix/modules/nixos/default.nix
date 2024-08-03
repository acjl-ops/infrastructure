{ config, lib, pkgs, inputs, ... }:
  with lib;
{
  # set state version based on used nixpkgs
  system.stateVersion = mkDefault lib.trivial.release;
}
