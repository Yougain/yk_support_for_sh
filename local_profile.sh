
if ! type _src_etc_local_profile_d >/dev/null 2>&1; then

    _src_etc_local_profile_d(){
        if [ -n "$ZSH_VERSION" ]; then
            # zsh
            if [[ ! -o login ]]; then
                for i in /usr/local/etc/profile.d/*.sh; do
                    [ -r "$i" ] && . "$i"
                done
            fi
        elif [ -n "$BASH_VERSION" ]; then
            # bashcd
            if ! shopt -q login_shell; then
                for i in /usr/local/etc/profile.d/*.sh; do
                    [ -r "$i" ] && . "$i"
                done
            fi
        fi
    }

    _src_etc_local_profile_d
fi