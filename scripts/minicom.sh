COMMAND = minicom -b 115200 -o -D /dev/ttyUSB0

kitty -e bash -lc "$COMMAND; exec bash" &
