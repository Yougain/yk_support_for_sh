require _temp_path end


END << 'EOF'
    rm -rf "$TMPDIR_YK" 2>/dev/null || true
EOF

local dir
for dir in /tmp/yktmp_dir.*; do
    if [ ${dir%%-*} != "/tmp/yktmp_dir.$SYS_BOOT_ID" ]; then
        rm -rf "$dir" 2>/dev/null || true
    fi
done

