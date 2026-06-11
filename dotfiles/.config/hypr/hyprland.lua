hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

local terminal    = "kitty"
local fileManager = "nemo"
local menu        = "puter-menu"

hl.workspace_rule({workspace = "1", default_name = "0", persistent = true, monitor = "HDMI-A-1"})
hl.workspace_rule({workspace = "2", default_name = "1", persistent = true, monitor = "HDMI-A-1"})
hl.workspace_rule({workspace = "3", default_name = "2", persistent = true, monitor = "HDMI-A-1"})
hl.workspace_rule({workspace = "4", default_name = "3", persistent = true, monitor = "HDMI-A-1"})
hl.workspace_rule({workspace = "5", default_name = "4", persistent = true, monitor = "HDMI-A-1"})
hl.workspace_rule({workspace = "6", default_name = "5", persistent = true, monitor = "HDMI-A-1"})
hl.workspace_rule({workspace = "7", default_name = "6", persistent = true, monitor = "HDMI-A-1"})
hl.workspace_rule({workspace = "8", default_name = "7", persistent = true, monitor = "HDMI-A-1"})
hl.workspace_rule({workspace = "9", default_name = "8", persistent = true, monitor = "HDMI-A-1"})
hl.workspace_rule({workspace = "10", default_name = "9", persistent = true, monitor = "HDMI-A-2"})


hl.on("hyprland.start", function ()
        hl.exec_cmd("nm-applet")
        hl.exec_cmd("dunst")
        hl.exec_cmd("hyprpaper")
        hl.exec_cmd("waybar")
        hl.exec_cmd("wl-paste --watch cliphist store")
        hl.exec_cmd("mpd")
        hl.exec_cmd("mpd-notify")

        -- hl.dispatch(hl.dsp.workspace.rename({workspace = 1,  name = "0"}))
        -- hl.dispatch(hl.dsp.workspace.rename({workspace = 2,  name = "1"}))
        -- hl.dispatch(hl.dsp.workspace.rename({workspace = 3,  name = "2"}))
        -- hl.dispatch(hl.dsp.workspace.rename({workspace = 4,  name = "3"}))
        -- hl.dispatch(hl.dsp.workspace.rename({workspace = 5,  name = "4"}))
        -- hl.dispatch(hl.dsp.workspace.rename({workspace = 6,  name = "5"}))
        -- hl.dispatch(hl.dsp.workspace.rename({workspace = 7,  name = "6"}))
        -- hl.dispatch(hl.dsp.workspace.rename({workspace = 8,  name = "7"}))
        -- hl.dispatch(hl.dsp.workspace.rename({workspace = 9,  name = "8"}))
        -- hl.dispatch(hl.dsp.workspace.rename({workspace = 10, name = "9"}))

        -- hl.dispatch(hl.dsp.workspace.move({workspace = 1,  monitor = "HDMI-A-1"}))
        -- hl.dispatch(hl.dsp.workspace.move({workspace = 10, monitor = "HDMI-A-2"}))

        hl.exec_cmd("emacs",             { workspace = "1 silent" })
        hl.exec_cmd("firefox",           { workspace = "2 silent" })
        hl.exec_cmd("kitty -e btop",     { workspace = "10 silent" })
end)

hl.env("XCURSOR_SIZE", "32")
hl.env("HYPRCURSOR_SIZE", "32")

hl.config({
    general = {
        gaps_in  = 3,
        gaps_out = 5,

        border_size =  1,

        col = {
           active_border   = "rgba(f734c0ff)",
           inactive_border = "rgba(424e68ff)",
        },

        resize_on_border = false,

        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 0,
        rounding_power = 0,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

hl.config({
    dwindle = {
        preserve_split = true,
    },
})

hl.config({
    master = {
        new_status = "master",
    },
})

hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
})

hl.config({
    input = {
        kb_layout  = "gb",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",
        repeat_rate = 80,
        repeat_delay = 200,
        follow_mouse = 1,

        sensitivity = 0,

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})

-- Graphics Tablet
hl.device({
      name = "ugtablet-10-inch-pentablet-pen",
      output = "HDMI-A-1"
})

local mainMod = "SUPER"

hl.bind(mainMod .. "+ Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + W", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SemiColon", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + Apostrophe", hl.dsp.exec_cmd(menu .. " emoji"))
hl.bind(mainMod .. " + Period", hl.dsp.exec_cmd(menu .. " clipboard"))
hl.bind(mainMod .. " + Comma", hl.dsp.exec_cmd(menu .. " window"))
hl.bind(mainMod .. " + Slash", hl.dsp.exec_cmd("dunstctl close"))
hl.bind(mainMod .. " + SHIFT + Slash", hl.dsp.exec_cmd("dunstctl close-all"))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("puter-eyedropper"))
hl.bind(mainMod .. " + print", hl.dsp.exec_cmd("puter-screenshot"))
hl.bind(mainMod .. " + SHIFT + print", hl.dsp.exec_cmd("puter-screenshot -full"))

hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + N", hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + P", hl.dsp.window.cycle_next({ false }))

hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen_state({ internal = 1, client = 0, "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen_state({ internal = 2, client = 0, "toggle" }))
hl.bind(mainMod .. " + G", hl.dsp.window.fullscreen_state({ internal = 0, client = 0, "toggle" }))

hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))

hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))

hl.bind(mainMod .. " + Grave", hl.dsp.focus({ workspace =  1}))
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace =  2}))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace =  3}))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace =  4}))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace =  5}))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace =  6}))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace =  7}))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace =  8}))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace =  9}))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace =  10}))

hl.bind(mainMod .. " + SHIFT + Grave", hl.dsp.window.move({ workspace =  1}))
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace =  2}))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace =  3}))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace =  4}))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace =  5}))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace =  6}))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace =  7}))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace =  8}))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace =  9}))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace =  10}))

-- hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
-- hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +1%"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -1%"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
      name = "runelite-tooltips",
      match = {
         class = "^(net-runelite-client-RuneLite)$",
         title = "^win(.*)$"
      },
      no_initial_focus = true,
})

hl.layer_rule({
      name = "nofadepls",
      match = {
         namespace = "rofi"
      },
      no_anim = true
})

-- Fix for flicking corners in waybar.
hl.layer_rule({
    match = {
        namespace = "waybar"
    },
    blur         = true,
    ignore_alpha = 0.4,
})
