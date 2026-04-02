#!/usr/bin/env bash

BASE="$HOME/.claude/projects"

# ----------------------------
# 快速找最新文件（避免全量 find）
# ----------------------------
INPUT_PATH="${1:-$(pwd -P)}"
PROJECT=$(echo "$INPUT_PATH" | sed 's#/#-#g; s#_#-#g')

FILE=$(ls -t "$BASE/$PROJECT"/*.jsonl 2>/dev/null | head -n 1)

[ -z "$FILE" ] && echo "-" && exit 0

format() {
  awk "BEGIN {printf \"%.1fk\", $1/1000}"
}

# ----------------------------
# 1️⃣ 累计 API cost（历史全部）
# ----------------------------
TOTAL_COST=$(jq -r '
  def u: .usage // .message.usage // empty;
  select(u != null)
  | (u.input_tokens // 0)
  + (u.output_tokens // 0)
' "$FILE" 2>/dev/null | awk '{s+=$1} END {print s+0}')

# ----------------------------
# 2️⃣ 当前 ctx（只看最后一条）
# ----------------------------
CURRENT_CTX=$(jq -r '
  def u: .usage // .message.usage // empty;
  select(u != null and u.input_tokens != null)
  | (
      u.input_tokens + u.output_tokens
    )
' "$FILE" 2>/dev/null | tail -n 1)

OUT_COST=$(format "$TOTAL_COST")
OUT_CTX=$(format "$CURRENT_CTX")

echo "$OUT_CTX/$OUT_COST"
