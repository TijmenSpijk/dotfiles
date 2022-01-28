#!/bin/bash
id=$(xdotool getwindowfocus)
window=$(xprop -id ${id} WM_CLASS)
if [[ $window = *"not found"* ]]
then 
    echo "Desktop"
else
    split=(${window//\"/ })
    echo ${split[4]^}
fi