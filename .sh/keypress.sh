#!/bin/sh

if [[ "$1" == "-h" || "$1" == "--help" || "$1" == "help" ]]; then
	printf "Usage:\n\tkeypress <device> <key0> [key1] [key..]\n"
	printf "\nExamples:\n"
	printf "\tkeypress /dev/input/event4 KEY_LEFTMETA KEY_D\n"
	exit
fi

device="$1"

for key in $@; do
	if [[ "$key" == "$device" ]]; then
		continue
	fi

	evemu-event "$device" --type EV_KEY --code "$key" --value 1 --sync
done

for (( idx=${#@}; idx>0; idx-- )); do
	if [[ "${!idx}" == "$device" ]]; then
		continue
	fi

	evemu-event "$device" --type EV_KEY --code "${!idx}" --value 0 --sync
done
