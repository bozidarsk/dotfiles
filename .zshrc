PROMPT=" %~ $ "
RPROMPT="[%?]"

alias ll='ls -la'
alias scan='scanimage -d "airscan:w0:CANNON INC. TS6250 series" -p --format=png -o "$HOME/Documents/$(date +DATE_FORMAT).png"'

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[H" beginning-of-line
bindkey "^[[1;6H" beginning-of-line
bindkey "^[[F"  end-of-line
bindkey "^[[1;6F" end-of-line

