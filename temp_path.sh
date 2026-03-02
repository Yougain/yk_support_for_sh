require _temp_path end


END << 'EOF'
	#echo `date '+%Y-%m-%d %H:%M:%S.%3N'` zsh[$$] erasing $TMPDIR_YK by END >> "/tmp/zsh_erase_tmp_dir.log"
    rm -rf "$TMPDIR_YK" 2>/dev/null || true
EOF


if [ "$SYS_BOOT_ID" != "$(awk '/^btime/ {print $2}' /proc/stat)" ]; then
    echo "System boot ID has changed." >&2
    echo "Press any key to exit." >&2
    read -n 1 -s
    exit 1
fi

local dir
for dir in /tmp/yk_tmp_dir.*; do
    if [ -w "$dir" ];then
        if [ ${dir%-*} != "/tmp/yk_tmp_dir.$SYS_BOOT_ID" ]; then
            rm -rf "$dir"
        else
            local fpid="${dir##*-}"
            local pid0="${fpid#*.}"
            local pid1="${pid0%.*}"
            if ! kill -0 "$pid1" >/dev/null 2>&1; then
				#echo `date '+%Y-%m-%d %H:%M:%S.%3N'` zsh[$$] erasing $dir by old SYS_BOOT_ID >> "/tmp/zsh_erase_tmp_dir.log"
                rm -rf "$dir"
            fi
        fi
    fi
done

