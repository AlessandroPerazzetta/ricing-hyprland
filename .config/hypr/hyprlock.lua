---@module 'hl'

-- sample hyprlock.conf

-- for more configuration options, refer https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock

--

-- rendered text in all widgets supports pango markup (e.g. <b> or <i> tags)

-- ref. https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/#general-remarks

--

-- shortcuts to clear password buffer: ESC, Ctrl+U, Ctrl+Backspace

--

-- you can get started by copying this config to ~/.config/hypr/hyprlock.conf

--

-- Select MainMonitor

-- None set == all monitors

--$mainMonitor =

local mainMonitor = "DP-1"

local font = "Monospace"

hl.config({
    general = {
        hide_cursor = false,
    },
})

-- uncomment to enable fingerprint authentication

-- auth {

--     fingerprint {

--         enabled = true

--         ready_message = Scan fingerprint to unlock

--         present_message = Scanning...

--         retry_delay = 250 # in milliseconds

--     }

-- }

hl.config({
    animations = {
        enabled = true,
    },
})

hl.config({
    background = {
        path = "screenshot",
        blur_passes = 3,
    },
})
-- NOTE: Section 'background' may be a plugin or custom section; verify the output

hl.config({
    input-field = {
        size = { "15%", "2%" },
        outline_thickness = 1,
        inner_color = { "rgba(0", 0, 0, "0.0)" },
        -- no fill
        outer_color = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
        check_color = { colors = { "rgba(00ff99ee)", "rgba(ff6633ee)" }, angle = 120 },
        fail_color = { colors = { "rgba(ff6633ee)", "rgba(ff0066ee)" }, angle = 40 },
        font_color = { "rgb(143", 143, "143)" },
        fade_on_empty = false,
        rounding = 2,
        font_family = "Monospace",
        placeholder_text = "Input password...",
        fail_text = PAMFAIL,
        -- uncomment to use a letter instead of a dot to indicate the typed password
        -- dots_text_format = *
        -- dots_size = 0.4
        dots_spacing = 0.3,
        -- uncomment to use an input indicator that does not show the password length (similar to swaylock's input indicator)
        -- hide_input = true
        position = { 0, -20 },
        halign = "center",
        valign = "center",
    },
})
-- NOTE: Section 'input-field' may be a plugin or custom section; verify the output

-- TIME

hl.config({
    label = {
        text = TIME,
        -- ref. https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/#variable-substitution
        font_size = 90,
        font_family = "Monospace",
        position = { -30, 0 },
        halign = "right",
        valign = "top",
    },
})
-- NOTE: Section 'label' may be a plugin or custom section; verify the output

-- DATE

hl.config({
    label = {
        text = "cmd[update:60000] date+ %A, %d %B %Y",
        -- update every 60 seconds
        font_size = 25,
        font_family = "Monospace",
        position = { -30, -150 },
        halign = "right",
        valign = "top",
    },
})
-- NOTE: Section 'label' may be a plugin or custom section; verify the output

hl.config({
    label = {
        text = { LAYOUT[it, "en]" },
        font_size = 24,
        onclick = "hyprctl switchxkblayout all next",
        position = { 250, -20 },
        halign = "center",
        valign = "center",
    },
})
-- NOTE: Section 'label' may be a plugin or custom section; verify the output
