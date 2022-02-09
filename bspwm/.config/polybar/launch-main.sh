#!/bin/bash

# Terminate already running bar instances
killall -s SIGKILL polybar
# If all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit

# Launch Polybar, using default config location ~/.config/polybar/config
polybar -c $HOME/.config/polybar/config-main bar 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar Launched"