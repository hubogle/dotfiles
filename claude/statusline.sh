#!/usr/bin/env bash
#
# Claude Code StatusLine
#
# 在 Herdr pane 内把模型名上报给侧边栏，同时输出 Claude Code 底部状态栏：
# 🤖 Fable 5.1 | 🌿 main +1 M2 ?3 | ███████░░░ 72%

set -u

# 一次 jq 取出全部字段；用 \x1f 分隔，tab 会让 read 折叠空字段导致错位。
IFS=$'\x1f' read -r MODEL_ID MODEL_DISPLAY DIR CTX < <(
  jq -rj '[
    (.model.id // ""),
    (.model.display_name // ""),
    (.workspace.current_dir // .cwd // "."),
    (.context_window.used_percentage // 0 | floor)
  ] | map(tostring) | join("\u001f")'
)

# ---- Herdr ---------------------------------------------------------------
if [ "${HERDR_ENV:-}" = "1" ] && [ -n "${HERDR_BIN_PATH:-}" ] && [ -n "${HERDR_PANE_ID:-}" ]; then
  "$HERDR_BIN_PATH" pane report-metadata "$HERDR_PANE_ID" \
    --source user:claude-sidebar \
    --token "model=${MODEL_DISPLAY:-${MODEL_ID:-unknown}}" \
    >/dev/null 2>&1 || true
fi

# ---- Git -----------------------------------------------------------------
BRANCH="-"
GIT_STATUS=""

if cd "$DIR" 2>/dev/null && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  BRANCH="$(git branch --show-current 2>/dev/null)"
  [ -n "$BRANCH" ] || BRANCH="$(git rev-parse --short HEAD 2>/dev/null || echo detached)"

  GIT_STATUS="$(git status --porcelain 2>/dev/null | awk '
    /^\?\?/            { u++; next }
    substr($0,1,1) != " " { s++ }
    substr($0,2,1) != " " { m++ }
    END {
      if (s) printf " +%d", s
      if (m) printf " M%d", m
      if (u) printf " ?%d", u
      if (!s && !m && !u) printf " clean"
    }')"
fi

# ---- Context bar ---------------------------------------------------------
BAR_WIDTH=10
FILLED=$((CTX * BAR_WIDTH / 100))
printf -v BAR '%*s' "$FILLED" ''
printf -v PAD '%*s' "$((BAR_WIDTH - FILLED))" ''
BAR="${BAR// /█}${PAD// /░}"

printf '🤖 %s | 🌿 %s%s | %s %d%%\n' \
  "${MODEL_DISPLAY:-${MODEL_ID:-unknown}}" "$BRANCH" "$GIT_STATUS" "$BAR" "$CTX"
