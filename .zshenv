export DATE_FORMAT=%Y%m%d_%H%M%S
export WINEPREFIX=~/.config/win32
export WINEARCH=win32
export SSH_AGENT_PID=$(ps -eo cmd,pid | grep ssh-agent | grep -v grep | grep -v sed | head -1 | sed -E 's/ssh-agent\s+([0-9]+)/\1/' | tr -d '\r' | tr -d '\n')
export SSH_AUTH_SOCK="$HOME/.ssh/agent/$(ls -t ~/.ssh/agent | tail -1 | tr -d '\r' | tr -d '\n')"
