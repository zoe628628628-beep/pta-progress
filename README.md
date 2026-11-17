# 家長會事務進度（加密頁）

公開網址上的 `index.html` 是加密過的，需輸入密碼才能看。密碼由家長會私下提供，不在此 repo 中。

- `tools/build.sh`：把 `private/index.plain.html`（不會上傳）加密成 `index.html`。密碼從本機 macOS 鑰匙圈讀取。
- `private/`、匯出的對話記錄等都列在 `.gitignore`，不會 commit。
