{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./nixos
    ./sanix/nixos.nix
  ];
}
