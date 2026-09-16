#!/usr/bin/env bash
#
# Claude Code StatusLine
#
# 1. 在 Herdr pane 内把模型名上报给侧边栏，按 context 使用率分到
#    model_low / model_mid / model_high，颜色在 herdr config.toml 里配置。
# 2. 输出 Claude Code 自己的底部状态栏：
#    🤖 Fable 5.1 | 🌿 main +1 M2 ?3 | ███████░░░ 72%

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
# 侧边栏第三行显示模型名，颜色反映 context 使用率：按阈值把模型名上报到
# model_low / model_mid / model_high 之一，其余两个清空（herdr 规则只能看
# token 自身的值，无法用 ctx 给模型名上色）。模型名用 display_name（如 Fable 5.1），
# pi 侧对应 model.name，口径一致；没有时退回 model.id。
if [ "${HERDR_ENV:-}" = "1" ] && [ -n "${HERDR_BIN_PATH:-}" ] && [ -n "${HERDR_PANE_ID:-}" ]; then
  if   [ "$CTX" -gt 70 ]; then TIER=high
  elif [ "$CTX" -gt 40 ]; then TIER=mid
  else                         TIER=low
  fi

  "$HERDR_BIN_PATH" pane report-metadata "$HERDR_PANE_ID" \
    --source user:claude-sidebar \
    --clear-token model_low --clear-token model_mid --clear-token model_high \
    --token "model_${TIER}=${MODEL_DISPLAY:-${MODEL_ID:-unknown}}" \
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
