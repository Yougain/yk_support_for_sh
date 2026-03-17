require _temp_path end


END << 'EOF'
	echo `date '+%Y-%m-%d %H:%M:%S.%3N'` zsh\[$$\] erasing $TMPDIR_YK by END >> "/tmp/zsh_erase_tmp_dir.log"
    rm -rf "$TMPDIR_YK" 2>/dev/null || true
EOF


local dir
for dir in /tmp/yk_tmp_dir.*; do
    if [ -w "$dir" ];then
        if [ ${dir%-*} != "/tmp/yk_tmp_dir.$SYS_BOOT_ID" ]; then
			echo `date '+%Y-%m-%d %H:%M:%S.%3N'` zsh\[$$\] erasing $dir by old SYSBOOT_ID >> "/tmp/zsh_erase_tmp_dir.log"
            rm -rf "$dir"
        else
            local fpid="${dir##*-}"
            local pid0="${fpid#*.}"
            local pid1="${pid0%.*}"
            if ! kill -0 "$pid1" >/dev/null 2>&1; then
				echo `date '+%Y-%m-%d %H:%M:%S.%3N'` zsh\[$$\] erasing $dir by non active zsh\[$pid1\] >> "/tmp/zsh_erase_tmp_dir.log"
                rm -rf "$dir"
            fi
        fi
    fi
done

local d
for dir in /var/tmp/yk_tmp_ipc.*/*; do
    if [ -w "$dir" ];then
        d="${dir##*/}"
        if [ ${d%-*} != "$SYS_BOOT_ID" ]; then
			echo `date '+%Y-%m-%d %H:%M:%S.%3N'` zsh\[$$\] erasing $dir by old SYSBOOT_ID >> "/tmp/zsh_erase_tmp_dir.log"
            rm -rf "$dir"
        else
            fpid="${d##*-}"
            pid0="${fpid#*.}"
            pid1="${pid0%.*}"
            if ! kill -0 "$pid1" >/dev/null 2>&1; then
				echo `date '+%Y-%m-%d %H:%M:%S.%3N'` zsh\[$$\] erasing $dir by non active zsh\[$pid1\] >> "/tmp/zsh_erase_tmp_dir.log"
                rm -rf "$dir"
            fi
        fi
    fi
done
