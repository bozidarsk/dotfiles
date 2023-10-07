while true; do
    lang=$(hyprctl devices | tr -d '\n' | sed -E 's/.+at-translated-set-2-keyboard\s+rules:( [rmlvo] "[a-zA-Z, ]*",?)+\s+active keymap: ([a-zA-Z]+ \([^:]+\)).+/\2/')

    if [[ $lang == *"Bulgarian"* ]]; then
        echo "bg"
    elif [[ $lang == *"Greek"* ]]; then
        echo "gr"
    else
        echo "en"
    fi
    
    sleep 0.1
done
