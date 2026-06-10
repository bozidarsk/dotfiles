PROMPT=" %~ $ "
RPROMPT="[%?]"

alias mysql="docker container start mysql-server; sleep 1; docker exec -it mysql-server mysql"
alias ilc="~/.nuget/packages/runtime.linux-x64.microsoft.dotnet.ilcompiler/8.0.0/tools/ilc"
alias camera-disable='sudo modprobe -r uvcvideo'
alias camera-enable='sudo modprobe uvcvideo'
alias ll='ls -lA'
alias scan='scanimage -d "escl:https://192.168.1.10:443" --progress --mode Color --format png -o "$HOME/Documents/$(date +'%Y%m%d_%H%M%S').png"'

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[H" beginning-of-line
bindkey "^[[1;6H" beginning-of-line
bindkey "^[[F"  end-of-line
bindkey "^[[1;6F" end-of-line
