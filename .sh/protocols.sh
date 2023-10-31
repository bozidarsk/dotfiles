if [[ $# -ne 1 ]]; then
	exit 1
fi

url=""
protocol=$(echo "$1" | sed -E 's/([a-z]+):\/\/(.*)/\1/')
arg=$(echo "$1" | sed -E 's/([a-z]+):\/\/(.*)/\2/')

if [[ $protocol == "cs" ]]; then
	url="https://learn.microsoft.com/en-us/dotnet/api/$arg"
elif [[ $protocol == "sof" ]]; then
	url="https://sofiatraffic.bg/bg/transport/virtual-tables/$arg"

	if [[ $arg == *"a"* ]]; then
		url="https://schedules.sofiatraffic.bg/autobus/$(echo $arg | sed -E 's/[a-z]*([0-9]+)/\1/')"
	elif [[ $arg == *"e"* ]]; then
		url="https://schedules.sofiatraffic.bg/electrobus/E$(echo $arg | sed -E 's/[a-z]*([0-9]+)/\1/')"
	elif [[ $arg == *"tr"* ]]; then
		url="https://schedules.sofiatraffic.bg/tramway/$(echo $arg | sed -E 's/[a-z]*([0-9]+)/\1/')"
	elif [[ $arg == *"tb"* ]]; then
		url="https://schedules.sofiatraffic.bg/trolleybus/$(echo $arg | sed -E 's/[a-z]*([0-9]+)/\1/')"
	elif [[ $arg == *"m"* ]]; then
		if [[ $arg == "m3" ]]; then
			url="https://schedules.sofiatraffic.bg/metro/M3"
		else
			url="https://schedules.sofiatraffic.bg/metro/M1-M2"
		fi
	fi
fi

xdg-open "$url"