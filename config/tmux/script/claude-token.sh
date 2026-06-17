#!/usr/bin/env bash

BASE="$HOME/.claude/projects"

INPUT_PATH="${1:-$(pwd -P)}"
PROJECT=$(echo "$INPUT_PATH" | sed 's#/#-#g; s#_#-#g')

FILE=$(ls -t "$BASE/$PROJECT"/*.jsonl 2>/dev/null | head -n 1)

[ -z "$FILE" ] && echo "-" && exit 0

format() {
  awk "BEGIN {printf \"%.1fk\", $1/1000}"
}

# ----------------------------
# 1️⃣ 当前 session 历史 token 处理量
# input + output + cache write + cache read
# ----------------------------
TOTAL_TOKENS=$(jq -r '
  def u: .usage // .message.usage // empty;

  select(u != null)
  | (
      (u.input_tokens // 0)
    + (u.output_tokens // 0)
    + (u.cache_creation_input_tokens // 0)
    + (u.cache_read_input_tokens // 0)
    )
' "$FILE" 2>/dev/null | awk '{s+=$1} END {print s+0}')

# ----------------------------
# 2️⃣ 当前上下文规模
# 只取最后一条 assistant usage
# input + cache write + cache read
# 不包含 output
# ----------------------------
CURRENT_CTX=$(jq -r '
  def u: .usage // .message.usage // empty;

  select(u != null)
  | select(
      (.type == "assistant")
      or (.message.role == "assistant")
      or (.type == null)
    )
  | (
      (u.input_tokens // 0)
    + (u.cache_creation_input_tokens // 0)
    + (u.cache_read_input_tokens // 0)
    )
' "$FILE" 2>/dev/null | tail -n 1)

[ -z "$CURRENT_CTX" ] && CURRENT_CTX=0
[ -z "$TOTAL_TOKENS" ] && TOTAL_TOKENS=0

OUT_CTX=$(format "$CURRENT_CTX")
OUT_TOTAL=$(format "$TOTAL_TOKENS")

echo "$OUT_CTX/$OUT_TOTAL"
