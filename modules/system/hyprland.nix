{ config, pkgs, ... }:

{
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
    };
  };

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  security.polkit.enable = true;
}
