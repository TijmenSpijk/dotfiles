#!/usr/bin/env bash
set -euo pipefail


sed -n '/START_KEYS/,/END_KEYS/p' ~/.xmonad/xmonad.hs | \
    grep -e ', ("' \
    -e '\[ (' \
    -e 'KB_GROUP' | \
    grep -v '\-\- , ("' | \
    sed -e 's/^[ \t]*//' \
    -e 's/, (/(/' \
    -e 's/\[ (/(/' \
    -e 's/-- KB_GROUP /\n/' \
    -e 's/", /"\t: /' | \
    yad --text-info --back=#1d1f21 --fore=#c5c8c6 --geometry=1920x1080
