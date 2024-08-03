{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./../../profiles/home/minimal.nix
  ];
}
