#!/bin/bash
HDMI1=$(xrandr --query | grep 'HDMI1')
if [[ $HDMI1 = *"connected"* ]]
then
    xrandr --output eDP1 --primary --mode 1920x1080 --rotate normal --output HDMI1 --mode 1920x1080 --rotate normal --above eDP1
    $HOME/.config/polybar/launch-main.sh
    $HOME/.config/polybar/launch-extra.sh
else
    xrandr --output eDP1 --primary --mode 1920x1080 --rotate normal
    $HOME/.config/polybar/launch-main.sh
fi
