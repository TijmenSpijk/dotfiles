#!/bin/bash
if [[ $(ping 1.1.1.1) = *"unreachable"* ]]
then
    echo 0
else
    echo 1
    # yay -S
    # yay -Qu | wc -l
fi