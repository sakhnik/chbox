#!/bin/bash

path=/sys/class/leds/chromeos::kbd_backlight

max_val=$(cat $path/max_brightness)
val=$(($1 * $max_val / 100))
[[ $val -gt 100 ]] && val=100

echo $val > $path/brightness
