#!/usr/bin/env bash
# tmux 状态栏的 Claude 会话计数分段（供 tmux-power.tmux 的 @claude_agents_status 调用）。
#
# 实现在 claude-tui 二进制里:`claude-tui status`。状态分类规则、@c-* 配色、
# hub window 枚举都与 popup 列表同源——此前这三处在 bash 里各有一份副本,
# 必须靠人工与 Rust 侧保持同步。这里只剩一层转发。
#
# 二进制未构建时输出 "-",让状态栏降级而不是报错。
set -euo pipefail

# 参数展开而不是 $(cd … && pwd):这段每 2 秒跑一次,那个子 shell 是纯开销,
# 而这里只需要一个能打开的路径,不需要它是规范化的绝对路径。
binary="${BASH_SOURCE[0]%/*}/claude-tui"

[ -x "$binary" ] && exec "$binary" status
echo "-"
