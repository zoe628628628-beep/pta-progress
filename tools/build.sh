#!/bin/bash
# 把 private/index.plain.html 加密成 index.html（可公開）。
# 密碼從 macOS 鑰匙圈讀取（服務名稱 pta-progress-page），不會印出、不會寫進檔案。
set -euo pipefail
cd "$(dirname "$0")/.."
SRC="private/index.plain.html"
ITER=300000
[ -f "$SRC" ] || { echo "找不到 $SRC" >&2; exit 1; }
PTA_PW="$(security find-generic-password -s pta-progress-page -w 2>/dev/null)" || { echo "鑰匙圈裡沒有 pta-progress-page 密碼" >&2; exit 1; }
export PTA_PW
PAYLOAD="$(openssl enc -aes-256-cbc -pbkdf2 -iter "$ITER" -md sha256 -salt -pass env:PTA_PW -in "$SRC" | base64 | tr -d '\n')"
unset PTA_PW
python3 -I - "$PAYLOAD" "$ITER" <<'EOF'
import sys
payload, it = sys.argv[1], sys.argv[2]
s = open('tools/shell.html', encoding='utf-8').read()
s = s.replace('__PAYLOAD__', payload).replace('__ITER__', it)
open('index.html', 'w', encoding='utf-8').write(s)
EOF
# 安全檢查：輸出裡不能出現原始內容
if grep -q '畢旅\|山川\|POLO' index.html; then echo "加密失敗：index.html 含有明文" >&2; rm -f index.html; exit 1; fi
echo "已產生加密的 index.html"
