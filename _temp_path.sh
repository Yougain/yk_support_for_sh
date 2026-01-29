require fpid

export TMPDIR_YK=/tmp/yk_tmp_dir.${SYS_BOOT_ID}-${FPID}
mkdir -p "$TMPDIR_YK"


temp_path(){
    echo -n "$TMPDIR_YK/$1.$RANDOM.$RANDOM"
}

