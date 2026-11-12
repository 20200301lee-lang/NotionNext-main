#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

echo "========================================"
echo "       NotionNext 一鍵啟動工具"
echo "========================================"
echo

if ! command -v node >/dev/null 2>&1; then
  echo "找不到 Node.js。請安裝 Node.js 22 LTS：https://nodejs.org/"
  exit 1
fi

if ! command -v yarn >/dev/null 2>&1; then
  echo "找不到 Yarn，正在嘗試安裝 Yarn 1..."
  npm install --global yarn
fi

if [ ! -f .env.local ]; then
  echo "第一次執行需要 Notion 頁面 ID。"
  echo "請從 Notion 頁面網址複製 32 碼 ID，或貼上完整網址。"
  read -r -p "請輸入 Notion Page ID：" NOTION_PAGE_ID
  if [ -z "$NOTION_PAGE_ID" ]; then
    echo "未輸入 Page ID，程式無法讀取 Notion 內容。"
    exit 1
  fi
  printf 'NOTION_PAGE_ID=%s\n' "$NOTION_PAGE_ID" > .env.local
  echo "已建立 .env.local 設定檔。"
fi

if [ ! -d node_modules ]; then
  echo "第一次執行，正在安裝套件，請稍候..."
  yarn install --frozen-lockfile
fi

echo
echo "正在啟動 NotionNext..."
echo "啟動後請開啟 http://localhost:3000"
echo "按 Ctrl+C 可停止網站。"
echo
yarn dev
