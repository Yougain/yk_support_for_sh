
require _temp_path

# グローバル変数
__END_EVALS_LOCAL=()
__ORIGINAL_EXIT_TRAP=""

# trapの再定義

# EXIT時に元のtrap＋END登録分をeval
__end_trap_handler() {
    # 元のEXIT trapがあれば実行
    if [ -n "$__ORIGINAL_EXIT_TRAP" ]; then
        eval "$__ORIGINAL_EXIT_TRAP"
    fi
    # ENDで登録された内容を順次eval
    for func in "${__END_EVALS_LOCAL[@]}"; do
        eval "$func"
    done
}

if [ -n "$BASH_VERSION" ]; then
    trap_register() {
        if [ "$#" -ge 2 ]; then
            local handler="$1"
            shift
            local other_signal_list=()
            for each_sig in "$@"; do
                if [ "$each_sig" = "EXIT" ]; then
                    # EXIT用trap登録
                    __ORIGINAL_EXIT_TRAP="$handler"
                else
                    other_signal_list+=("$each_sig")
                fi
                shift
            done
            if [ "${#other_signal_list[@]}" -gt 0 ]; then
                builtin trap "$handler" "${other_signal_list[@]}"
            fi
        fi
    }

    trap() {
        local opts=()
        local cmdline=()
        while [ "$#" -gt 0 ]; do
            local arg="$1"
            if [ "${arg#-}" != "$arg" ]; then
                if [ "$arg" = "--" ]; then
                    shift
                    cmdline+=("$@")
                    break
                fi
                opts+=("$arg")
            else
                cmdline+=("$arg")
            fi
            shift
        done
        if [ "${#opts[@]}" -gt 0 ]; then
            builtin trap "${opts[@]}"
        else
            trap_register "${cmdline[@]}"
        fi
    }

    # END関数：コードを__END_EVALS_LOCALに登録
    END() {
        local func_content
        read -r func_content
        __END_EVALS_LOCAL+=("$func_content")
    }


    # 現在のEXIT trapをファイルに保存し、EXIT時に__end_trap_handlerを呼ぶ
    __trap_info_file=$(temp_path trap_info)
    builtin trap > "$__trap_info_file"
    __ORIGINAL_EXIT_TRAP=$(grep 'EXIT' "$__trap_info_file" | sed -E 's/^[^`]*`(.*)`$/\1/')
    rm -f "$__trap_info_file" 2>/dev/null || true
    builtin trap '__end_trap_handler' EXIT
elif [ -n "$ZSH_VERSION" ]; then
    END() {
        local func_content
        func_content=$(cat)
        __END_EVALS_LOCAL+=("$func_content")
        local zshexit_body="$(functions zshexit | sed '1d;$d')"
        zshexit_body="$(print -r -- "$zshexit_body" | sed '1s/^[ \t]*//; $s/[ \t]*$//')"
        if [ -z "$zshexit_body" -o "$zshexit_body" = ":" ]; then
            zshexit(){
                __end_trap_handler                
            }
        elif [ "$zshexit_body" != "__end_trap_handler" ]; then
            __ORIGINAL_EXIT_TRAP="$zshexit_body"
            zshexit(){
                __end_trap_handler                
            }
        fi
    }
else
    err "Unsupported shell for end.sh"
fi
