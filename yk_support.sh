
if ! type __yk_support_for_sh_loaded >/dev/null 2>&1; then
    . /usr/local/lib/yk_support_for_sh/err.sh
    __yk_support_for_sh_loaded(){
        YK_SUPPORT_LIB_SH=/usr/local/lib/yk_support_for_sh
        YK_SUPPORT_SHRC_D=/usr/local/etc/yk_support_for_sh/shrc.d
        require(){
            local i
            for i in "$@"; do
                local vn=YK_SUPPORT_FOR_SH_MODULES_LOADED_OF_$i
                eval "local vnc=\$${vn}"
                if [ -n "$vnc" ]; then
                    continue
                fi
                local module_name="$i"
                local yk_module_path="$YK_SUPPORT_LIB_SH/$module_name.sh"
                local module_content=""
                if [ -f "$yk_module_path" ]; then
                    module_content="$(<$yk_module_path)" 2>/dev/null || module_content=""
                    eval "YK_SUPPORT_FOR_SH_MODULES_LOADED_OF_$i=1"
                    eval "
                        __yk_setup_for_require_$i(){
                            $module_content
                        }
                        __yk_setup_for_require_$i
                        unset -f __yk_setup_for_require_$i
                    "
                else
                    err "Module '$module_name' not found at '$yk_module_path'" >&2
                fi
            done
        }
        __yk_load_profile_d(){
            if [ -n "$BASH_VERSION" ]; then
                shopt -s nullglob 2>/dev/null || true
            elif [ -n "$ZSH_VERSION" ]; then
                setopt nullglob 2>/dev/null || true
            fi
            for i in $YK_SUPPORT_SHRC_D/*.sh; do
                if [ "$(readlink -f "$i" >/dev/null 2>&1)" = "$(readlink -f "$YK_SUPPORT_LIB_SH/$(basename -- "$i")" >/dev/null 2>&1)" ]; then
                    require $(basename -- "${i%.sh}")
                else
                    [ -r "$i" ] && . "$i"
                fi
            done
        }
        if [ -n "$ZSH_VERSION" ]; then
            # zsh
            __yk_load_profile_d
        elif [ -n "$BASH_VERSION" ]; then
            # bashcd
            __yk_load_profile_d
        fi
    }
    __yk_support_for_sh_loaded
fi

