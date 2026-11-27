{ inputs, lib, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      shell = {
        setup_wizard_enabled = false;
        launch_apps_as_systemd_services = true;

	polkit_agent = true;
        telemetry_enabled = false;
        screen_time_enabled = false;
        clipboard_enabled = false;

        launcher = {
          layout = "simple";
          track_usage = false;
          sort_by_usage = false;
          fetch_exchange_rates = false;
        };

        panel = {
          transparency_mode = "solid";
          launcher_placement = "floating";
          launcher_position = "center";
          control_center_placement = "attached";
        };
      };

      theme = {
        mode = "dark";
        shell_mode = "dark";
        source = "builtin";
        builtin = "Tokyo-Night";
        pure_black_dark = true;
        sync_color_scheme = true;
      };

      wallpaper = {
        enabled = true;
        default.path = "color:#24272e";
        automation.enabled = false;
      };

      bar.main = {
        position = "top";
        thickness = 32;
        reserve_space = true;

        background_opacity = 1.0;
        compositor_blur = false;
        shadow = false;

        radius = 0;
        margin_ends = 0;
        margin_edge = 0;

        padding = 12;
        widget_spacing = 8;
        capsule = false;

        start = [
          "workspaces"
        ];

        center = [
          "clock"
        ];

        end = [
	  "weather"
          "tray"
          "notifications"
          "network"
          "volume"
          "control-center"
        ];
      };

      widget.clock = {
        format = "{:%a %d %b  %H:%M}";

        actions.left =
          "panel-toggle control-center calendar";
      };

      # lockscreen = {
      #   enabled = true;
      #   grace_period_seconds = 0;
      # };

      # Does not have auto suspend because it is always plugged in
      # to allow for background tasks.
      lockscreen = {
        enabled = true;
        lock_before_suspend = true;
        grace_period_seconds = 0;
      
        blurred_desktop = false;
        transition = [];
      };
      
      idle = {
        pre_action_fade_seconds = 2.0;
      
        behavior = {
          lock = {
            enabled = true;
            timeout = 300;
            action = "lock";
          };
      
          screen-off = {
            enabled = true;
            timeout = 600;
            action = "screen_off";
          };

          suspend = {
            enabled = true;
            timeout = 1800;
            action = "lock_and_suspend";
          };
        };
      };


      dock.enabled = false;
      desktop_widgets.enabled = false;
      
      location = {
        auto_locate = false;
        address = "Gurgaon, Haryana, India";
      };

      weather = {
        enabled = true;
        refresh_minutes = 30;
        unit = "metric";
        effects = false;
      };
      
      widget.weather = {
        show_condition = false;
        show_temperature = true;
      };
    };
  };

  # Only start Noctalia in UWSM-managed Hyprland.
  systemd.user.services.noctalia = {
    Unit = {
      PartOf = lib.mkForce [
        "graphical-session.target"
      ];

      After = lib.mkForce [
        "wayland-session-waitenv.service"
      ];

      Before = lib.mkForce [
        "graphical-session.target"
      ];
    };

    Install.WantedBy = lib.mkForce [
      "wayland-session@hyprland.desktop.target"
    ];
  };
}

