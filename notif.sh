#!/bin/bash

case $1 in
    up)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
        ;;
    down)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        ;;
    mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;
    micmute)
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        ;;
    brightup)
        brightnessctl set 5%+
        ;;
    brightdown)
        brightnessctl set 5%-
        ;;
esac

if [[ "$1" == "brightup" || "$1" == "brightdown" ]]; then
    CURRENT=$(brightnessctl get)
    MAX=$(brightnessctl max)
    BRIGHT_NUM=$(( 100 * CURRENT / MAX ))
    
    notify-send -h string:x-canonical-private-synchronous:brightness -h int:value:"$BRIGHT_NUM" "Brightness"

elif [ "$1" = "micmute" ]; then
    if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q "MUTED"; then
        notify-send -h string:x-canonical-private-synchronous:volume "Microphone" "Muted"
    else
        notify-send -h string:x-canonical-private-synchronous:volume "Microphone" "Active"
    fi
else
    VOLUME_NUM=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}')
    if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED"; then
        notify-send -h string:x-canonical-private-synchronous:volume "Volume" "Muted"
    else
        notify-send -h string:x-canonical-private-synchronous:volume -h int:value:"$VOLUME_NUM" "Volume"
    fi
fi
