#!/usr/bin/env bash

# Determine `systemd-logind` or `(e)logind`.
if [ -x "$(command -v systemctl)" ]; then
    SEATCTL='systemctl'
elif [ -x "$(command -v loginctl)" ]; then
    SEATCTL='loginctl'
else
    echo "failed"
fi

ROFI="rofi -theme $HOME/.scripts/rofi/themes/five-horizontal.rasi"

A='' B='' C='' D='' E=''

MENU="$(printf "${A}\n${B}\n${C}\n${D}\n${E}\n" | ${ROFI} -dmenu -selected-row 2)"

case "$MENU" in
    "$A") exec "${HOME}/.scripts/rofi/promptmenu.sh" \
              --yes-command "${SEATCTL} poweroff --no-wall" \
              -q 'Poweroff?'
    ;;
    "$B") exec "${HOME}/.scripts/rofi/promptmenu.sh" \
              --yes-command "${SEATCTL} reboot --no-wall" \
              --query ' Reboot?'
    ;;
    "$C") exec "${HOME}/.scripts/rofi/promptmenu.sh" \
              --yes-command "dm-tool switch-to-greeter" \
              --query '  Lock?'
    ;;
    "$D") exec "${HOME}/.scripts/rofi/promptmenu.sh" \
              --yes-command "${SEATCTL} hybrid-sleep" \
              --query ' Suspend?'
    ;;
    "$E") exec "${HOME}/.scripts/rofi/promptmenu.sh" \
              --yes-command "${HOME}/.scripts/logout.sh" \
              -q ' Logout?'
    ;;
esac 

exit ${?}
