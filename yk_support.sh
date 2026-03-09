
if ! type __yk_support_for_sh_loaded >/dev/null 2>&1; then
    . "$YK_PREFIX/lib/yk_support_for_sh/err.sh"
    __yk_support_for_sh_loaded(){
        require(){
            local i
            if [ "$1" = "-q" ]; then
                shift
                local query=1
            fi
            for i in "$@"; do
                local vn=YK_SUPPORT_FOR_SH_MODULES_LOADED_OF_$i
                eval "local vnc=\$${vn}"
                if [ -n "$vnc" ]; then
                    continue
                fi
                local module_name="$i"
                local XSH=
                if [ -n "$ZSH_VERSION" ]; then
                    XSH=zsh
                elif [ -n "$BASH_VERSION" ]; then
                    XSH=bash
                else
                    XSH=
                fi
                local YK_SUPPORT_LIB_SH=
                local YK_SUPPORT_SHRC_D=
                local SH=
                for SH in $XSH sh; do
                    YK_SUPPORT_LIB_SH="$YK_PREFIX/lib/yk_support_for_$SH"
                    YK_SUPPORT_SHRC_D="$YK_PREFIX/etc/yk_support_for_$SH/$SH"rc.d
                    if [ -f "$YK_SUPPORT_LIB_SH/$module_name.$SH" ]; then
                        local yk_module_path="$YK_SUPPORT_LIB_SH/$module_name.$SH"
                        local module_content=""
                        module_content="$(<$yk_module_path)" 2>/dev/null || module_content=""
                        eval "YK_SUPPORT_FOR_SH_MODULES_LOADED_OF_$i=1"
                        eval "
                            __yk_setup_for_require_$i(){
                                $module_content
                            }
                            __yk_setup_for_require_$i
                            unset -f __yk_setup_for_require_$i
                        "
                        break
                    fi
                done
                eval "vnc=\$${vn}"
                if [ -z "$vnc" ]; then
                    if [ -n "$query" ]; then
                        return 1
                    fi
                    err "Module '$module_name' not found." >&2
                    return 1
                fi
            done
            return 0
        }
        __yk_load_profile_d(){
            local XSH
            if [ -n "$ZSH_VERSION" ]; then
                XSH=zsh
            elif [ -n "$BASH_VERSION" ]; then
                XSH=bash
            else
                XSH=
            fi
            local YK_SUPPORT_SHRC_D=
            local YK_SUPPORT_LIB_SH=
            local SH=
            for SH in $XSH sh; do
                YK_SUPPORT_SHRC_D="$YK_PREFIX/etc/yk_support_for_$SH/$SH"rc.d
                YK_SUPPORT_LIB_SH="$YK_PREFIX/lib/yk_support_for_$SH"
                if ! ls "$YK_SUPPORT_SHRC_D"/*."$SH" 1>/dev/null 2>&1; then
                    continue
                fi
                for i in $YK_SUPPORT_SHRC_D/*.$SH; do
                    if [ "$i" = "$YK_SUPPORT_SHRC_D/*.$SH" ]; then
                        break
                    fi
                    if [ "$(readlink -f "$i" >/dev/null 2>&1)" = "$(readlink -f "$YK_SUPPORT_LIB_SH/$(basename -- "$i")" >/dev/null 2>&1)" ]; then
                        require $(basename -- "${i%.$SH}")
                    else
                        [ -r "$i" ] && . "$i"
                    fi
                done
            done
        }
        if [ -n "$ZSH_VERSION" ]; then
            # zsh
            __yk_load_profile_d
        elif [ -n "$BASH_VERSION" ]; then
            # bash
            __yk_load_profile_d
        fi
    }
    __yk_support_for_sh_loaded
fi

