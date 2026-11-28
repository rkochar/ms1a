{ config, pkgs, ... }:

{
  services.greetd = {
    enable = true;
    useTextGreeter = true;

    settings = {
      default_session = {
        user = "greeter";

        command = builtins.concatStringsSep " " [
          "${pkgs.tuigreet}/bin/tuigreet"
          "--time"
          "--remember"
          "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"
          "--cmd '${config.programs.uwsm.package}/bin/uwsm start -e -D Hyprland hyprland.desktop'"
        ];
      };
    };
  };
}

