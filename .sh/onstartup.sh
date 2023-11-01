hyprpaper & disown
waybar & disown
swaync & disown
playerctld daemon & disown
wl-paste --type text/plain --watch cliphistory store text & disown
wl-paste --type image/png --watch cliphistoty store image & disown
#rclone mount "Google Drive:" "$HOME/Google Drive" & disown
hyprctl setcursor "$CURSOR_THEME" 24 & disown
libinput debug-events --show-keycodes | media-menu window & disown

