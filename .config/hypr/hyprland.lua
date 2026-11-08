hl.monitor({ output = "", mode = "1920x1200@165", position = "auto", scale = 1 })

hl.env("TERM", "alacritty")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Nordic-cursors")
hl.env("HYPRCURSOR_THEME", "Nordic-cursors")
hl.env("CURSOR_THEME", "Nordic-cursors")
hl.env("GTK_THEME", "Colloid-Dark-Nord")

hl.on("hyprland.start", function()
    hl.exec_cmd("mkdir /tmp/thumbnails")
    hl.exec_cmd('rclone mount "Google Drive:" "$HOME/Google Drive"')
    hl.exec_cmd('rclone mount "Proton Drive:" "$HOME/Proton Drive"')
    hl.exec_cmd("wl-clip-persist --clipboard regular")
    hl.exec_cmd([[wl-paste --type text --watch $SHELL -c 'tee /tmp/clipboard-text && quickshell ipc call clipboard storeText']])
    hl.exec_cmd([[wl-paste --type image --watch $SHELL -c 'base64 | tee /tmp/clipboard-image && quickshell ipc call clipboard storeImage']])
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("hyprsunset -i")
    hl.exec_cmd("quickshell")
    hl.exec_cmd("quickshell ipc call shell reload")
    hl.exec_cmd('sh -c \'eval $(ssh-agent)\'')
    hl.exec_cmd('sh -c \'while true; do if [[ $(cat /sys/class/power_supply/BAT1/capacity) -le 5 && $(cat /sys/class/power_supply/BAT1/status) != Charging ]]; then brightnessctl set 100%; fi && sleep 5; done\'')
end)

hl.config({
    input = {
        kb_layout = "us, bg, gr",
        kb_variant = "euro, phonetic, polytonic",
        follow_mouse = 2,
        float_switch_override_focus = 0,
        numlock_by_default = true,
        accel_profile = "adaptive",
        scroll_method = "2fg",
        sensitivity = 0.1,
        touchpad = {
            natural_scroll = true,
            tap_to_click = true,
            disable_while_typing = false,
            scroll_factor = 0.8,
        },
    },

    cursor = {
        no_warps = true,
    },

    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border = "rgba(89a3c2ff)",
            inactive_border = "rgba(454951ff)",
        },
        layout = "dwindle",
    },

    decoration = {
        rounding = 5,
        rounding_power = 3,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        dim_special = 1,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        focus_on_activate = true,
        close_special_on_empty = false,
    },
})

hl.device({ name = "razer-razer-basilisk-v2", sensitivity = 0, accel_profile = "custom 1 0 1" })
hl.device({ name = "razer-razer-basilisk-v2-1", sensitivity = 0, accel_profile = "custom 1 0 1" })

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "up", action = "fullscreen", mode = "maximize" })
hl.gesture({ fingers = 3, direction = "down", action = "fullscreen", mode = "maximize" })
hl.gesture({ fingers = 4, direction = "up", action = "fullscreen" })
hl.gesture({ fingers = 4, direction = "down", action = "fullscreen" })

hl.bind("CONTROL + ALT + Delete", hl.dsp.exec_cmd("hyprctl dispatch exit"), { locked = true })
hl.bind("SUPER + C", hl.dsp.window.close())
hl.bind("ALT + F4", hl.dsp.window.close())

hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))

hl.bind("ALT + Tab", hl.dsp.window.cycle_next())
hl.bind("ALT + Tab", hl.dsp.window.bring_to_top())
hl.bind("ALT + SHIFT + Tab", hl.dsp.window.cycle_next({ next = false }))
hl.bind("ALT + SHIFT + Tab", hl.dsp.window.bring_to_top())

hl.bind("F11", hl.dsp.window.fullscreen({ mode = 0, action = "toggle" }))
hl.bind("SUPER + SHIFT + up", hl.dsp.window.swap({ direction = "up" }))
hl.bind("SUPER + SHIFT + down", hl.dsp.window.swap({ direction = "down" }))
hl.bind("SUPER + SHIFT + left", hl.dsp.window.swap({ direction = "left" }))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.swap({ direction = "right" }))

hl.bind("SUPER + ALT + up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind("SUPER + ALT + down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
hl.bind("SUPER + ALT + left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + ALT + right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })

hl.bind("SUPER + CONTROL + right", hl.dsp.focus({ workspace = "+1" }))
hl.bind("SUPER + CONTROL + left", hl.dsp.focus({ workspace = "-1" }))
hl.bind("SUPER + CONTROL + SHIFT + right", hl.dsp.window.move({ workspace = "+1" }))
hl.bind("SUPER + CONTROL + SHIFT + left", hl.dsp.window.move({ workspace = "-1" }))

hl.bind("SUPER + D", hl.dsp.workspace.toggle_special())
hl.bind("SUPER + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + J", hl.dsp.layout("togglesplit"))

hl.bind("SUPER + Space", hl.dsp.exec_cmd("hyprctl switchxkblayout all next && quickshell ipc call languages update"))
hl.bind("SUPER + SHIFT + Space", hl.dsp.exec_cmd("hyprctl switchxkblayout all prev && quickshell ipc call languages update"))
hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("quickshell ipc call clipboard open"))
hl.bind("SUPER + T", hl.dsp.exec_cmd("alacritty"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("nemo"))
hl.bind("SUPER + R", hl.dsp.exec_cmd("rofi -show run"))
hl.bind("SUPER + P", hl.dsp.exec_cmd("hyprpicker | wl-copy"))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd([[grim -g "$(slurp)" /proc/self/fd/1 | tee "$HOME/Pictures/Screenshots/Screenshot_$(date +'%Y%m%d_%H%M%S').png" | wl-copy]]))

hl.bind("SUPER + KP_Add", hl.dsp.exec_cmd([[zsh -c "hyprctl eval \"hl.config({ cursor = { zoom_factor = $(hyprctl getoption cursor:zoom_factor | grep float | sed -E 's/float: (.+)/\1/' | awk '{ x = $1 + 0.1; print (x > 5.0 ? 5.0 : x) }') } })\""]]), { repeating = true })
hl.bind("SUPER + KP_Subtract", hl.dsp.exec_cmd([[zsh -c "hyprctl eval \"hl.config({ cursor = { zoom_factor = $(hyprctl getoption cursor:zoom_factor | grep float | sed -E 's/float: (.+)/\1/' | awk '{ x = $1 - 0.1; print (x < 1.0 ? 1.0 : x) }') } })\""]]), { repeating = true })

for i = 1, 9 do
    hl.bind("SUPER + " .. i, hl.dsp.exec_cmd("quickshell ipc call appLauncher run " .. (i - 1)))
end

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ && quickshell ipc call sound update"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && quickshell ipc call sound update"), { repeating = true, locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && quickshell ipc call sound update"), { locked = true })
hl.bind("XF86Launch6", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl --machine --class backlight set 5%+ && quickshell ipc call brightness update"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl --machine --class backlight set 5%- && quickshell ipc call brightness update"), { repeating = true, locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86RFKill", hl.dsp.exec_cmd("quickshell ipc call rfkill update"), { locked = true })
hl.bind("XF86TouchpadOn", hl.dsp.exec_cmd("quickshell ipc call touchpadtoggle update true"), { locked = true })
hl.bind("XF86TouchpadOff", hl.dsp.exec_cmd("quickshell ipc call touchpadtoggle update false"), { locked = true })

hl.bind("SUPER_L", hl.dsp.exec_cmd("quickshell ipc call appLauncher toggle"), { release = true })
hl.bind("SUPER_L", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"), { release = true })

hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
    idle_inhibit = "fullscreen",
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})

