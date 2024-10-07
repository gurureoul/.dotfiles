function get_battery {
	read -r CAPACITY < /sys/class/power_supply/BAT?/capacity
	read -r STATUS < /sys/class/power_supply/BAT?/status

	BAT_LABEL=""
	if [[ "$STATUS" == "Charging" ]] || [[ "$STATUS" == "Full" ]]; then
		BAT_LABEL="AC"
	else
		BAT_LABEL="NC"
	fi

	if [ "$CAPACITY" -ge 85 ]; then
		echo "$BAT_LABEL: %B%F{green}$CAPACITY%%%f%b"
	elif [ "$CAPACITY" -ge 65 ]; then
		echo "$BAT_LABEL: %%F{green}$CAPACITY%%%f"
	elif [ "$CAPACITY" -ge 45 ]; then
		echo "$BAT_LABEL: %%F{yellow}$CAPACITY%%%f"
	elif [ "$CAPACITY" -ge 25 ]; then
		echo "$BAT_LABEL: %%F{red}$CAPACITY%%%f"
	else
		echo "$BAT_LABEL: %%B%F{red}$CAPACITY%%%f%b"
	fi
}

# Lines configured by zsh-newuser-install
setopt extendedglob nomatch notify
unsetopt autocd beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/reoul/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -Uz vcs_info
precmd() { vcs_info }

zstyle ':vcs_info:git:*' formats '%b '

setopt prompt_subst
PS1='%F{yellow}%n%f%F{red}@%m%f | '
RPS1='$(get_battery)'

alias dotfiles='$(which git) --git-dir=$HOME/.dotfiles --work-tree=$HOME'
