#!/bin/bash

kill bspwm_notify_si

last_notify=0
min_interval=5  # в секундах

bspc subscribe node_focus node_geometry | while read -r _ _ _ _ _; do
    now=$(date +%s.%N)
    diff=$(echo "$now - $last_notify" | bc)
    is_ready=$(echo "$diff > $min_interval" | bc)

    if [ "$is_ready" -eq 1 ]; then
        wid=$(bspc query -N -n focused)
        if [ -z "$wid" ]; then
            continue
        fi

        geom=$(xwininfo -id "$wid" | awk '
          /Width:/ {w=$2}
          /Height:/ {h=$2}
          /Absolute upper-left X:/ {x=$4}
          /Absolute upper-left Y:/ {y=$4}
          END {print x"," y " " w "x" h}
        ')

        notify-send "$geom" -t 5000
        last_notify=$now
    fi
done
