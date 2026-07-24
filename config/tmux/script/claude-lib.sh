#!/usr/bin/env bash
# tmux claude 脚本公共库:被 list.sh / claude-status.sh / launch.sh source。
# 只定义函数,不产生副作用;不应直接执行。

# 读 tmux 全局选项,空则回退默认值:tmux_get <option> <default>
tmux_get() {
  local v
  v="$(tmux show-option -gqv "$1" 2>/dev/null)"
  printf '%s' "${v:-$2}"
}

# 枚举所有 claude-* tmux 会话的 pane_pid(每行一个)。
# 这是"哪些会话算数"的唯一入口:先按名字过滤 claude-*,再取 pane_pid——
# 因 launch.sh 用 exec,pane_pid == claude 进程 pid == <pid>.json 文件名,
# 据此只读列表内会话对应的 json(而非整个 sessions 目录,避免被无关 claude 进程干扰)。
claude_session_pids() {
  tmux list-sessions -f "#{m:${prefix:-claude-}*,#{session_name}}" \
    -F '#{pane_pid}' 2>/dev/null
}

# 一次性把 @c-* 主题色载入全局变量(含 tmux_get fork;之后按变量引用零 fork),
# 供 list.sh / claude-status.sh 共用同一套配色。按颜色命名(非角色),因黄/绿/灰
# 在两处身兼多职:黄=待授权/一般等待/git 变动数,绿=git 新增,灰=空闲/git 分支。
# 角色→颜色的映射留在各消费者(它们还要各带 label/rank/图标等呈现)。
claude_load_colors() {
  local name val
  # 先铺默认值,再用一次 show-options 批量覆盖(1 次 fork,取代逐色 7 次 tmux_get)
  CLR_YELLOW='#e0af68'   # 待授权 / 一般等待 / git 变动数
  CLR_ORANGE='#ff9e64'   # 待回答
  CLR_BLUE='#7aa2f7'     # 运行中
  CLR_GREEN='#73daca'    # git 新增
  CLR_RED='#f7768e'      # git 删除
  CLR_GREY='#787c99'     # 空闲 / git 分支
  CLR_BG='#1A1B26'       # 胶囊文字所用背景色
  while read -r name val; do
    val=${val#\"}; val=${val%\"}          # tmux 可能给值加引号
    case "$name" in
      @c-yellow) CLR_YELLOW=$val ;;
      @c-orange) CLR_ORANGE=$val ;;
      @c-blue)   CLR_BLUE=$val ;;
      @c-green)  CLR_GREEN=$val ;;
      @c-red)    CLR_RED=$val ;;
      @c-bwhite) CLR_GREY=$val ;;
      @c-bg)     CLR_BG=$val ;;
    esac
  done < <(tmux show-options -g 2>/dev/null)
}

# 把一份 claude 会话 json 归类成展示类别,结果写入 REPLY。
# 通过变量回传而非 echo:不 fork,可在遍历大量会话的紧循环里直接调用。
#   claude_classify <json>  ->  REPLY = permission|question|waiting|working|idle
# 规则(picker 与状态栏同源):
#   status=waiting + waitingFor=permission prompt → permission 待授权
#   status=waiting + waitingFor=user input        → question   待回答
#   status=waiting + 其他                          → waiting    一般等待
#   status=busy                                    → working    运行中
#   其他(idle / 空 / 未知)                        → idle       空闲
claude_classify() {
  local st="" wf=""
  case "$1" in *'"status":"'*)     st="${1#*\"status\":\"}";     st="${st%%\"*}" ;; esac
  case "$1" in *'"waitingFor":"'*) wf="${1#*\"waitingFor\":\"}"; wf="${wf%%\"*}" ;; esac
  case "$st" in
    waiting)
      case "$wf" in
        'permission prompt') REPLY=permission ;;
        'user input')        REPLY=question ;;
        *)                   REPLY=waiting ;;
      esac ;;
    busy) REPLY=working ;;
    *)    REPLY=idle ;;
  esac
}

# 状态已持续时长(duration = now - statusUpdatedAt):只取最高位单位。
# 例:3s / 12m / 5h / 1d。fmt_ago <epoch秒> <now> -> REPLY(空/非法 -> '-')
fmt_ago() {
  local at=$1 now=$2 dur
  case "$at" in ''|*[!0-9]*) REPLY='-'; return ;; esac
  dur=$(( now - at )); (( dur < 0 )) && dur=0
  if   (( dur >= 86400 )); then REPLY="$(( dur / 86400 ))d"
  elif (( dur >= 3600 ));  then REPLY="$(( dur / 3600 ))h"
  elif (( dur >= 60 ));    then REPLY="$(( dur / 60 ))m"
  else                          REPLY="${dur}s"
  fi
}
