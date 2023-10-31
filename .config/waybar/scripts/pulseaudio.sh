while true; do
    volume=$(pactl get-sink-volume @DEFAULT_SINK@ | tr -d '\n' | sed -E 's/.+\s+([0-9]+)%.+/\1/')
    alt="default"

    if [[ $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: yes" ]]; then
        alt="mute"
    fi

    echo "{\"percentage\": $volume, \"tooltip\": \"$volume%\", \"alt\": \"$alt\"}"
    sleep 0.05
done
