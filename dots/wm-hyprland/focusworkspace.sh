#!/bin/sh

if hyprctl activewindow | grep 'workspace:.*(special:scratchpad)$' > /dev/null 2>&1; then
    hyprctl dispatch togglespecialworkspace scratchpad
fi

hyprctl dispatch workspace "$@"
