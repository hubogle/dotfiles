#!/usr/bin/env bash
# 打开常驻 claude-tui 管理 session，并通过 popup 展示：左 Rust 列表，右 Claude 原生 tmux client。
set -euo pipefail

# Repeated P/S may be handled by the nested tmux client inside the popup.
# Closing the outer popup sends that client SIGHUP; the launcher must survive
# long enough to clear its single-popup marker instead of returning 129.
trap '' HUP

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/claude-lib.sh"
binary="$script_dir/claude-tui"
caller_client="${1:-}"
selected_window="${2:-}"
popup_client_option="@claude_tui_popup_client"
# 会话名/hub 名的解析规则只在 claude-lib.sh 里有一份,别处不再抄。
manager="$(claude_manager_session)"
hub="$(claude_hub_session)"

active_popup_client="$(tmux show-option -gqv "$popup_client_option" 2>/dev/null || true)"
reuse_active_popup=0

# 切换列表选中项的两个键，左右两个 pane 里都生效 —— 在 Claude 输入框里按也
# 能换会话，不必先跳回左边。可用 tmux option 改键。
#
# 它们绑在 root 键表上，因为按下时键盘在最内层那个 client（右侧 pane 里
# attach 到 hub 的那个）手上，前缀键那一层根本轮不到；而 root 表是全服务器
# 共享的,所以只在 popup 打开期间绑定、关闭时立刻解绑 —— 平时不占用户的键。
cycle_next="$(tmux_get @claude_tui_cycle_next 'M-n')"
cycle_prev="$(tmux_get @claude_tui_cycle_prev 'M-p')"

# 送的是方向键本身,而不是另一套"切换会话"的逻辑 —— 列表里按 j/k 和这里按
# 快捷键走的是同一条路（App::move_selection),两者不会有一天对不上。焦点留在
# 原处:TUI 只在自己本来就持有键盘时才把焦点收回去（见 App::switch_terminal)。
#
# 目标 pane 在绑定时就固定下来。这两个键曾经各转一次 claude-cycle.sh,于是
# 每按一下就是一个 bash + source 一遍公共库 + 三次 tmux 调用,只为算出一个
# 在 popup 打开期间根本不会变的 pane id（respawn-pane 复用 pane,id 不变)。
# 长按 M-n 时那是一串进程。
#
# 代价是 manager session 若在绑定残留期间消失,按键会报一句 "can't find pane"
# —— 而脚本版会静默退出。只有 launcher 异常终止（两条清理路径都没走到)才会
# 留下残留绑定,且下次按 P 就会重新绑到正确的 pane 上,窗口期很短。
bind_cycle_keys() {
  # $list_pane 由下面的 manager session 分支解析,调用点在其后。
  #
  # `|| true`:脚本是 set -e,而这两个键是锦上添花 —— 用户把
  # @claude_tui_cycle_next 设成一个 tmux 不认的键名时,该失败的是这两个绑定,
  # 不是整个 popup。
  tmux bind-key -n "$cycle_next" send-keys -t "$list_pane" Down || true
  tmux bind-key -n "$cycle_prev" send-keys -t "$list_pane" Up || true
}

unbind_cycle_keys() {
  tmux unbind-key -n "$cycle_next" 2>/dev/null || true
  tmux unbind-key -n "$cycle_prev" 2>/dev/null || true
}

# The @claude_tui_popup_client marker can go stale when a popup dies without
# passing through either cleanup path (outer client detach, abnormal kill).
# Use real state as the source of truth: while the popup is shown a client is
# attached to the manager session; once hidden none is.  Trusting the marker
# alone turns a stale flag into a "phantom hide" that wastes one keypress.
popup_shown=0
if tmux has-session -t "$manager" 2>/dev/null &&
   [ -n "$(tmux list-clients -t "$manager" -F '#{client_name}' 2>/dev/null)" ]; then
  popup_shown=1
fi

# Reconcile a stale marker before either branch reads it.
if [ "$popup_shown" -eq 0 ] && [ -n "$active_popup_client" ]; then
  tmux set-option -g -u "$popup_client_option" 2>/dev/null || true
  active_popup_client=""
fi

if [ "$selected_window" = "--toggle" ]; then
  if [ "$popup_shown" -eq 1 ]; then
    # Still genuinely shown -> hide.  -C drops the outer popup layer; the
    # detach is a fallback that forces the nested attach to exit even if the
    # caller client is unknown.
    if [ -n "$active_popup_client" ]; then
      tmux display-popup -c "$active_popup_client" -C 2>/dev/null || true
    fi
    tmux detach-client -s "$manager" 2>/dev/null || true
    tmux set-option -g -u "$popup_client_option" 2>/dev/null || true
    unbind_cycle_keys
    exit 0
  fi
  selected_window=""
fi

# O refreshes an existing manager popup in place.  Closing and reopening it
# would send SIGHUP to the nested client that may have triggered the action.
if [ -n "$selected_window" ] && [ "$popup_shown" -eq 1 ]; then
  caller_client="${active_popup_client:-$caller_client}"
  reuse_active_popup=1
fi

# 取文件 mtime（epoch 秒）；macOS 与 GNU stat 参数不同。
mtime() { stat -f '%m' "$1" 2>/dev/null || stat -c '%Y' "$1" 2>/dev/null; }

# 二进制随本目录一起分发（预编译,arm64 macOS),仓库里不再保留 Rust 源码。
# 缺失时直说并退出:从前这里会弹一个 popup 跑 cargo build，那条路现在既没有
# 源码可编译,产物路径也与这里的 $binary 对不上。
#
# 报错而不是静默退出:run-shell 是后台执行的,静默失败等于按了 P 什么也没发生,
# 而这恰恰是最需要解释的一次——通常是 rcm 没同步出这个软链,或换了架构。
if [ ! -x "$binary" ]; then
  tmux display-message -d 4000 "claude-tui 二进制不可用：$binary"
  exit 1
fi
binary_marker="$(mtime "$binary")"

if ! tmux has-session -t "$manager" 2>/dev/null; then
  info="$(tmux new-session -d -P -F '#{session_id} #{pane_id}' -s "$manager" -n manager 'exec tail -f /dev/null')"
  read -r manager_id list_pane <<<"$info"
  terminal_pane="$(tmux split-window -d -h -p 74 -t "$list_pane" -P -F '#{pane_id}' 'exec tail -f /dev/null')"
  tmux set-option -t "$manager_id" status off
  tmux set-option -t "$manager_id" pane-border-status off
  tmux set-option -t "$manager_id" pane-border-lines single 2>/dev/null || true
  tmux set-window-option -t "$list_pane" remain-on-exit on
  tmux set-window-option -t "$terminal_pane" remain-on-exit on
  tmux set-option -t "$manager_id" @claude_tui_terminal_pane "$terminal_pane"
else
  manager_id="$(tmux display-message -p -t "$manager" '#{session_id}')"
  list_pane="$(tmux list-panes -t "$manager" -F '#{pane_id}' | head -n 1)"
fi

tmux set-option -t "$manager_id" pane-border-style "fg=$(tmux_get @c-gray '#3B4261')"
tmux set-option -t "$manager_id" pane-active-border-style "fg=$(tmux_get @c-magenta '#bb9af7')"

if [ -n "$selected_window" ]; then
  tmux set-option -t "$manager_id" @claude_tui_selected_window "$selected_window"
fi

# hub 的状态栏由 claude-launch.sh 建 window 时一次性关闭,不在这里保存/还原:
# tmux 的 status 属于整个 session 而非单个 client,过去那套"进来关、出去还原"
# 每次显示/隐藏都要读写一个全局 option,而 hub 本就只透过 popup 露面。
tmux select-pane -t "$list_pane"
bind_cycle_keys

current_command="$(tmux display-message -p -t "$list_pane" '#{pane_current_command}' 2>/dev/null || true)"
running_marker="$(tmux show-options -qv -t "$manager_id" @claude_tui_binary_marker 2>/dev/null || true)"
if [ "$current_command" != claude-tui ] || [ "$running_marker" != "$binary_marker" ]; then
  # 新进程启动时自己会同步 load 一次,不必再催。
  tmux respawn-pane -k -t "$list_pane" "exec '$binary' --manager"
  tmux set-option -t "$manager_id" @claude_tui_binary_marker "$binary_marker"
else
  # 让常驻 TUI 立即重新读一遍,而不是等下一轮轮询。
  #
  # 能走到这里的只有两种情况:popup 即将显示,或者复用一个已显示的 popup ——
  # 隐藏那条路径在上面就 exit 了。两种都该刷新,所以这里不再挑 $selected_window:
  # 从前只有 claude-launch.sh 那条路（带 window id)会催一次,于是 prefix + P
  # 唤出的列表最多陈旧一轮轮询(2s),git 状态最多陈旧一个 TTL(6s) —— 而 worker
  # 里那句"launcher 会在重新 attach 前发 Ctrl-R"的注释是照着这里写的。
  #
  # 发 F5 而不是 C-r。两者在 TUI 里是不同的意图:C-r 是用户说"这个面板上所有
  # 东西都过期了",连额度也一起重查——那要起一个交互式 shell 跑 claude CLI,
  # 好几秒。而这里只是想让列表跟上,每次显示都发。曾经这里发的是 C-r,于是
  # 每开一次面板就重查一次额度,10 分钟的缓存形同虚设。
  # 真过期的额度仍会自己刷新:usage 线程每秒醒一次,到期且可见就查。
  #
  # `|| true`:脚本是 set -e,一次失败的刷新提示不该连 popup 都打不开。
  tmux send-keys -t "$list_pane" F5 || true
fi

if [ "$reuse_active_popup" -eq 1 ]; then
  exit 0
fi

popup_width="$(tmux_get @claude_tui_popup_width '95%')"
popup_height="$(tmux_get @claude_tui_popup_height '90%')"
# 把百分比换算成具体列/行,并与客户端同奇偶 —— 居中时 margin 才是整列,popup
# 不会落在半列上、每次重绘往不同方向舍入,内容也就不再左右晃动。这个助手一直
# 在 claude-lib.sh 里,却从没有人调用,于是它注释里描述的抖动照旧存在。
# 无 client 或取尺寸失败时原样退回百分比字符串,交给 tmux 自己处理。
claude_popup_dims "$caller_client" "$popup_width" "$popup_height"
popup_width="$REPLY"
popup_height="$REPLY2"
tmux set-option -g "$popup_client_option" "$caller_client"
printf -v popup_command 'exec env -u TMUX TERM=screen-256color tmux attach-session -t %q' "$manager_id"

# This call blocks until the popup closes.  A concurrent toggle (or the nested
# client detaching) tears the popup down with SIGHUP, so display-popup returns
# 129 — that is the normal close path, not a failure.  Swallow it and exit 0 so
# run-shell does not surface a spurious error.
if [ -n "$caller_client" ]; then
  tmux display-popup -c "$caller_client" -E -w "$popup_width" -h "$popup_height" "$popup_command" || true
else
  tmux display-popup -E  -w "$popup_width" -h "$popup_height" "$popup_command" || true
fi

# The popup has closed, however it closed — this is the path a q/Ctrl-P from
# inside it takes, as well as an outer client detaching.  The cycle keys only
# mean anything while it is open, so they go with it.
unbind_cycle_keys

# If no Claude windows remain in the hub there is nothing
# left to manage, so tear the manager session down.  Doing it here — from the
# user's client rather than inside the manager — avoids the self-kill race a
# nested process hits when it kills its own session, and the popup is already
# gone so detach-on-destroy can't leave a stray client behind.  A normal hide
# (q / Ctrl-P) with windows still present keeps the manager for reuse.
hub_windows="$(tmux list-windows -t "$hub" -F '#{@claude_window}' 2>/dev/null | grep -c '^1$' || true)"
if [ "${hub_windows:-0}" -eq 0 ] && tmux has-session -t "$manager" 2>/dev/null; then
  tmux kill-session -t "$manager" 2>/dev/null || true
fi
exit 0
