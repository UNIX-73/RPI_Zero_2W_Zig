#!/usr/bin/env bash
set -euo pipefail

DEVICE="/dev/ttyUSB0"
BAUD="115200"
COMMAND="minicom -b ${BAUD} -o -D ${DEVICE}"

kitty -e ${COMMAND} &
