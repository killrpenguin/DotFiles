#!/usr/bin/env bash

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar-msg cmd quit

laptop_id="eDP"

for m in $(polybar --list-monitors | cut -d":" -f1); do
	if [[ "$m" == *"$laptop_id"* ]]; then
    		MONITOR=$m polybar --reload laptop &
	else
    		MONITOR=$m polybar --reload hdmi &
	fi
done
