#!/usr/bin/env bash

input=$(cat)

MODEL=$(jq -r '.model.display_name // .model.id // "unknown"' <<<"$input")
DIR=$(jq -r '.workspace.current_dir // .cwd // "."' <<<"$input")
CTX=$(jq -r '.context_window.used_percentage // 0 | floor' <<<"$input")

cd "$DIR" 2>/dev/null || true

BRANCH="-"
GIT_STATUS=""

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)

    if [ -z "$BRANCH" ]; then
        BRANCH=$(git rev-parse --short HEAD 2>/dev/null || echo "detached")
    fi

    STATUS=$(git status --porcelain 2>/dev/null)

    if [ -n "$STATUS" ]; then
        STAGED=$(printf '%s\n' "$STATUS" | awk 'substr($0,1,1) != " " && substr($0,1,2) != "??" {n++} END {print n+0}')
        MODIFIED=$(printf '%s\n' "$STATUS" | awk 'substr($0,2,1) != " " && substr($0,1,2) != "??" {n++} END {print n+0}')
        UNTRACKED=$(printf '%s\n' "$STATUS" | awk 'substr($0,1,2) == "??" {n++} END {print n+0}')

        [ "$STAGED" -gt 0 ] && GIT_STATUS="${GIT_STATUS} +${STAGED}"
        [ "$MODIFIED" -gt 0 ] && GIT_STATUS="${GIT_STATUS} M${MODIFIED}"
        [ "$UNTRACKED" -gt 0 ] && GIT_STATUS="${GIT_STATUS} ?${UNTRACKED}"
    else
        GIT_STATUS=" clean"
    fi
fi

BAR_WIDTH=10
FILLED=$((CTX * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))

BAR=""
[ "$FILLED" -gt 0 ] && printf -v PART "%${FILLED}s" && BAR="${PART// /█}"
[ "$EMPTY" -gt 0 ] && printf -v PART "%${EMPTY}s" && BAR="${BAR}${PART// /░}"

printf '🤖 %s | 🌿 %s%s | %s %d%%\n' \
    "$MODEL" "$BRANCH" "$GIT_STATUS" "$BAR" "$CTX"