



error="\033[41m\033[33mERROR    :\033[m \033[31m"
warning="\033[43m\033[31mWARNING:\033[m \033[33m"
info="\033[46m\033[34mINFO     :\033[m \033[36m"
debug="\033[42m\033[34mDEBUG     :\033[m \033[32m"
plain="\033[m"
normal="\033[m"



function errmsg_n(){
    echo -ne $error$@$plain >&2
}

function errmsg(){
    errmsg_n "$@"
    if [ -n "$ERRMSG" ];then
        ERRMSG="$ERRMSG"'
'"$@"
    else
        ERRMSG="$@"
    fi
    echo -ne "\n" >&2
}


err(){
    errmsg "$@"
}
error(){
    errmsg "$@"
}


function info_n(){
    echo -ne $info$@$plain >&2
}
function info(){
    info_n $@
    echo -ne "\n" >&2
}


function warning_n(){
    echo -ne "$warning""$@"$plain  >&2
}
function warning(){
    warning_n "$@"
    echo -ne "\n" >&2
}

function warn(){
    warning_n "$@"
    echo -ne "\n" >&2
}

warn_n(){
    warning_n "$@" >&2
}

