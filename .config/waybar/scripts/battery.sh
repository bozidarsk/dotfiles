battery=$1
canlow=1
cancritical=1

while true; do
    capacity=$(cat /sys/class/power_supply/$battery/capacity)
    status=$(cat /sys/class/power_supply/$battery/status | awk '{print tolower($1)}')

    if [[ (($status == "full" || $capacity == 100)) && $status != "discharging"  ]]; then
        status="charging"
    fi

    class=$status

    if [[ $capacity -le 10 ]]; then
        class="$class critical"
	if [[ $cancritical -eq 1 && $status == "discharging" ]]; then
		notify-send -u critical -t 7000 "Battery level critical."
		cancritical=0
	fi
    elif [[ $capacity -le 20 ]]; then
        class="$class low"
	if [[ $canlow -eq 1 && $status == "discharging" ]]; then
	       	notify-send -u normal -t 5000 "Battery level low."
		canlow=0
	fi
    fi

    if [[ $capacity -gt 10 ]]; then cancritical=1
    elif [[ $capacity -gt 20 ]]; then canlow=1
    fi

    echo "{\"percentage\": $capacity, \"class\": \"$class\", \"alt\": \"$status\"}"
    sleep 1
done
