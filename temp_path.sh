require _temp_path end


END << 'EOF'
    rm -rf "$TMPDIR_YK" 2>/dev/null || true
EOF

local dir
for dir in /tmp/yk_tmp_dir.*; do
    if [ ${dir%%-*} != "/tmp/yk_tmp_dir.$SYS_BOOT_ID" -a -w "$dir" ]; then
        rm -rf "$dir"
    fi
done

