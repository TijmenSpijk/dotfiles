#!/bin/bash

# Launch Polybar, using default config location ~/.config/polybar/config
polybar -c $HOME/.config/polybar/config-extra bar 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar Launched"