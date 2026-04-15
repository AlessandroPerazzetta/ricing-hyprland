#!/bin/bash

# Check if hypridle is currently running
if pgrep -x "hypridle" > /dev/null; then
    IS_RUNNING=true
else
    IS_RUNNING=false
fi

if [[ "$1" == "toggle" ]]; then
    if [ "$IS_RUNNING" = true ]; then
        # Kill hypridle to prevent sleep (Inhibit ON)
        pkill hypridle
        #notify-send "Hyprland" "Sleep Inhibited (Caffeine ON)" -i nightly
        hyprctl notify -1 1500 "rgb(00ff11)" "fontsize:11 Sleep Inhibited (Caffeine ON)"
    else
        # Restart hypridle to allow sleep (Inhibit OFF)
        hypridle &
        #notify-send "Hyprland" "Sleep Enabled (Caffeine OFF)" -i sleep
        hyprctl notify -1 1500 "rgb(ff0011)" "fontsize:11 Sleep Enabled (Caffeine OFF)"
    fi
else
    # Output for Waybar (Logic is flipped: Running = Normal icon, Not Running = Inhibited icon)
    if [ "$IS_RUNNING" = true ]; then
        echo '{"text": "󰒲", "class": "normal", "tooltip": "Hypridle Active: System will sleep"}'
    else
        echo '{"text": "󰛐", "class": "inhibited", "tooltip": "Hypridle Inactive: System will stay awake"}'
    fi
fi
