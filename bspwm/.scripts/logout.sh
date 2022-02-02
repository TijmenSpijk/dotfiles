#!/usr/bin/env bash

user="$(loginctl list-users | grep `whoami`)"
split=(${user//\"/ })
exec loginctl terminate-user ${split[0]}