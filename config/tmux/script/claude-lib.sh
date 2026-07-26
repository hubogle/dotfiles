#!/usr/bin/env bash
# tmux claude 脚本公共库:被 claude-launch.sh source。
# 只定义函数,不产生副作用;不应直接执行。
#
# 状态分类、@c-* 配色载入、时长格式化曾经也在这里,与 claude-tui 的 Rust 实现
# 各存一份。它们已统一到 `claude-tui status`,此处不再保留
# 副本——两份实现无法靠注释保持同步。

# 读 tmux 全局选项,空则回退默认值:tmux_get <option> <default>
tmux_get() {
  local v
  v="$(tmux show-option -gqv "$1" 2>/dev/null)"
  printf '%s' "${v:-$2}"
}

# Claude CLI 统一入口。可用 @claude_command 覆盖；默认命令在非交互 tmux
# 环境中不可见时，优先使用 mise 的 shim，保证 launch 与额度查询使用同一 CLI。
claude_command() {
  local cmd
  cmd="$(tmux_get @claude_command 'claude')"
  if [ "$cmd" = claude ] && [ -x "$HOME/.mise/shims/claude" ]; then
    cmd="$HOME/.mise/shims/claude"
  fi
  printf '%s' "$cmd"
}

# Claude Code 统一承载在一个 tmux session 内；每个实例对应一个带
# @claude_window=1 标记的 window。管理用的 claude-tui window 不带该标记。
claude_hub_session() {
  tmux_get @claude_hub_session "${CLAUDE_HUB_SESSION:-claude}"
}

# 承载 claude-tui popup 的常驻管理 session。
claude_manager_session() {
  tmux_get @claude_tui_session 'claude-tui'
}

# popup 里的按键来自嵌套 client:左侧列表 client 挂在 manager session 上,右侧
# Claude 原生 client 挂在 hub 上。二者都不该再触发"在当前路径新建 Claude"——
# 那里的 pane_current_path 是 $HOME。
#   client_inside_popup <client> -> 0 表示在 popup 内
# client -> session 只能走 list-clients:display-message 的 -c 指定的是消息发往
# 哪个 client,格式串仍按"当前"目标展开,#{client_session} 会对任何 -c 都给出
# 同一个答案(实测三个 client 全被判成 hub)。
client_inside_popup() {
  local client=$1 session
  [ -z "$client" ] && return 1
  session="$(tmux list-clients -F '#{client_name}	#{client_session}' 2>/dev/null |
    awk -F'\t' -v c="$client" '$1 == c { print $2; exit }')"
  [ -n "$session" ] &&
    { [ "$session" = "$(claude_hub_session)" ] || [ "$session" = "$(claude_manager_session)" ]; }
}

# 把 @claude_popup_width/height 的百分比换算成具体列/行,并让其与目标客户端
# **同奇偶** —— 居中时左右(上下)margin = (client - popup)/2 恒为整列/整行,
# 消除 popup 落在半列上、每次重绘舍入方向不定导致的内容左右晃动。
#   popup_dims <client> <width_opt> <height_opt> -> REPLY=宽 REPLY2=高
# 无 client 或取尺寸失败时,原样回退百分比字符串(交给 tmux 自行处理)。
popup_dims() {
  local client=$1 wopt=$2 hopt=$3 cw ch
  REPLY=$wopt; REPLY2=$hopt
  [ -z "$client" ] && return
  cw=$(tmux display-message -p -c "$client" '#{client_width}'  2>/dev/null)
  ch=$(tmux display-message -p -c "$client" '#{client_height}' 2>/dev/null)
  case "$cw" in ''|*[!0-9]*) return ;; esac
  case "$ch" in ''|*[!0-9]*) return ;; esac
  case "$wopt" in *%) REPLY=$(( cw * ${wopt%\%} / 100 )) ;; esac
  case "$hopt" in *%) REPLY2=$(( ch * ${hopt%\%} / 100 )) ;; esac
  (( (cw - REPLY)  % 2 )) && (( REPLY-- ))     # 与客户端同奇偶 -> margin 为整列
  (( (ch - REPLY2) % 2 )) && (( REPLY2-- ))
  (( REPLY  < 2 )) && REPLY=2
  (( REPLY2 < 2 )) && REPLY2=2
  return 0
}

# Claude 的全屏 popup 预留宿主 session 顶部的一行 status。宽高仍可由
# @claude_popup_width / @claude_popup_height 覆盖；只有默认的 100% 高度才扣行。
# claude_popup_dims <client> <width_opt> <height_opt> -> REPLY=宽 REPLY2=高
claude_popup_dims() {
  popup_dims "$@"
  if [ "$3" = '100%' ] && [[ $REPLY2 =~ ^[0-9]+$ ]] && (( REPLY2 > 1 )); then
    REPLY2=$(( REPLY2 - 1 ))
  fi
  return 0
}
