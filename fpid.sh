
# システムブート時刻を取得（UNIX時刻から文字列に変換）
SYS_BOOT_ID=$(awk '/^btime/ {print $2}' /proc/stat)

# プロセス開始クロック数を取得（/proc/$$/statの22番目のフィールド）
PROC_START_CLOCK=$(awk '{print $22}' /proc/$$/stat)

# 一意のプロセスID（FPID）を生成
FPID="${PROC_START_CLOCK}.$$"

# 1. クロックティック数取得
SYS_CLK_TCK=$(getconf CLK_TCK)





