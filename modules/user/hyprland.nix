{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    fuzzel
    nautilus
    wl-clipboard
  ];

  programs.kitty = {
    enable = true;

    font = {
      name = "MesloLGS NF";
      size = 12;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;

    # NixOS owns the compositor and portal packages.
    package = null;
    portalPackage = null;

    # UWSM manages the session lifecycle.
    systemd.enable = false;

    # Hyprland 0.55+ uses native Lua.
    configType = "lua";

    extraConfig = ''
      -- Monitors
      -- Default monitor configuration
      hl.monitor({
        output = "",
        mode = "1920x1080@60",
        position = "auto",
        scale = 1,
      })

      -- hl.monitor({
      --   output = "",
      --   mode = "preferred",
      --   position = "auto",
      --   scale = "auto",
      -- })

      -- Appearance and window management
      hl.config({
        general = {
          gaps_in = 5,
          gaps_out = 8,
          border_size = 2,
          layout = "dwindle",

          col = {
            active_border = "rgba(94a3b8ff)",
            inactive_border = "rgba(333840ff)",
          },

          resize_on_border = true,
        },

        decoration = {
          rounding = 6,
          active_opacity = 1.0,
          inactive_opacity = 1.0,

          blur = {
            enabled = false,
          },

          shadow = {
            enabled = false,
          },
        },

        animations = {
          enabled = true,
        },

        dwindle = {
          preserve_split = true,
        },

        misc = {
          disable_hyprland_logo = true,
          force_default_wallpaper = 0,
        },

        input = {
          kb_layout = "us",
          follow_mouse = 1,

          touchpad = {
            natural_scroll = true,
            tap_to_click = true,
          },
        },
      })

      -- Keybindings
      local mod = "SUPER"
      local bind = hl.bind
      local dsp = hl.dsp

      -- Applications
      bind(mod .. " + Return",
        dsp.exec_cmd("uwsm app -- kitty"))

      -- bind(mod .. " + Space",
      --   dsp.exec_cmd("fuzzel --launch-prefix='uwsm app --'"))

      -- Desktop shell
      bind(mod .. " + Space",
        dsp.exec_cmd("noctalia msg panel-toggle launcher"))
      
      bind(mod .. " + S",
        dsp.exec_cmd("noctalia msg panel-toggle control-center"))

      bind(mod .. " + Escape",
        dsp.exec_cmd("noctalia msg panel-toggle session"))

      bind(mod .. " + L",
        dsp.exec_cmd("loginctl lock-session"))
      
      -- Fallback launcher
      bind(mod .. " + SHIFT + Space",
        dsp.exec_cmd("fuzzel --launch-prefix='uwsm app --'"))


      bind(mod .. " + E",
        dsp.exec_cmd("uwsm app -- nautilus"))

      bind(mod .. " + B",
        dsp.exec_cmd("uwsm app -- firefox"))

      -- Window management
      bind(mod .. " + Q",
        dsp.window.close())

      bind(mod .. " + F",
        dsp.window.fullscreen())

      bind(mod .. " + V",
        dsp.window.float({ action = "toggle" }))

      -- Focus and move windows
      for _, direction in ipairs({
        "left", "right", "up", "down"
      }) do
        bind(mod .. " + " .. direction,
          dsp.focus({ direction = direction }))

        bind(mod .. " + SHIFT + " .. direction,
          dsp.window.move({ direction = direction }))
      end

      -- Workspaces: 1-9, 0 represents workspace 10
      for i = 1, 10 do
        local key = i % 10

        bind(mod .. " + " .. key,
          dsp.focus({ workspace = i }))

        bind(mod .. " + SHIFT + " .. key,
          dsp.window.move({ workspace = i }))
      end

      -- Mouse-driven window management
      bind(mod .. " + mouse:272",
        dsp.window.drag(), { mouse = true })

      bind(mod .. " + mouse:273",
        dsp.window.resize(), { mouse = true })

      -- Audio
      bind("XF86AudioRaiseVolume",
        dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
        { repeating = true })

      bind("XF86AudioLowerVolume",
        dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
        { repeating = true })

      bind("XF86AudioMute",
        dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))

      -- Session
      bind(mod .. " + SHIFT + E",
        dsp.exec_cmd("uwsm stop"))
    '';
  };
}
