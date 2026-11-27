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

  # Hyprland manages ordinary keyboard input directly.
  # TODO: ibus should be gone when Gnome is taken out
  i18n.inputMethod.enable = false;
}
