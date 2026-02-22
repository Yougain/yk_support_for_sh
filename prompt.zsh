case "${UID}" in
0)
    mode_color="%{${fg[red]}%}"
    bold_start="%B"
    bold_end="%b"
    ;;
*)
    mode_color="%{${fg[cyan]}%}"
    ;;
esac
case ${UID} in
0)
	prompt_symbol="#"
	prompt_symbol_with_color="%{${fg[red]}%}#%{${reset_color}%}"
	;;
*)
	prompt_symbol="$"
	prompt_symbol_with_color="%{${fg[green]}%}\$%{${reset_color}%}"
esac

PROMPT="${bold_start}[$mode_color%n@%m %{$fg[yellow]%}%~%{${reset_color}%}${bold_start}]${prompt_symbol_with_color}$bold_end "
RPROMPT="%{${fg[magenta]}%}%*%{${reset_color}%}"
