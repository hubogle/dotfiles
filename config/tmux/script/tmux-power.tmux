#!/usr/bin/env bash
# $1: option
# $2: default value
tmux_get() {
    local value="$(tmux show -gqv "$1")"
    [ -n "$value" ] && echo "$value" || echo "$2"
}

# $1: option
# $2: value
tmux_set() {
    tmux set-option -gq "$1" "$2"
}
# 使用该方法设置值，tmux 页面会被刷新，shift 选择文本时

# black="#282C34" # one_dark_pro_flat
# white="#d7dae0" # one_dark_pro_flat

black="#1E1E1E" # vscode 背景色
white="#D4D4D4" # vscode 背景色
red="#e05561" # e05561 ff616e
green="#8cc265" # 8cc265 a5e075
yellow="#d18f52" # d18f52 f0a45d
blue="#4aa5f0" # 4aa5f0 4dc4ff
magenta="#c162de" # c162de de73ff
cyan="#42b3c2" # 42b3c2 4cd1e0
visual_grey="#3e4452"
comment_grey="#5c6370"

FG="$white"  # 前景色
BG="$black"  # 背景色


right_arrow_icon='' # e0b0
right_arrow_icon_inverse='' # e0d7

left_arrow_icon='' # e0b2
left_arrow_icon_inverse='' # e0d6

# https://man7.org/linux/man-pages/man1/tmux.1.html
#==========通用颜色配置=================
# tmux_set popup-border-style "bg=$BG,fg=$BG" # popup 边缘背景色

tmux_set status-style "fg=$FG" # 状态栏样式

tmux_set message-style "fg=$FG"          # 消息前景背景色
tmux_set message-command-style "fg=$FG"  # 设置状态行消息命令样式

tmux_set pane-border-style "fg=$visual_grey" # 设置面板默认分割线的颜色
tmux_set pane-active-border-style "fg=$green" # 设置活动面板分割线的颜色

tmux_set display-panes-colour "$blue"          # 设置窗格颜色
tmux_set display-panes-active-colour "$yellow" # 设置活动窗格颜色

tmux_set mode-style "bg=#202529,fg=#91A8BA" # 设置复制模式下的高亮颜色

tmux_set window-status-separator ""

tmux_set clock-mode-colour "$TC"        # 时钟模式
tmux_set clock-mode-style 24

# nobold 禁用粗体，noitalics 禁止倾斜文字 nounderscore 禁用下划线
#==================Windows状态栏=======
HOST_NAME="#(~/.config/tmux/script/hostname.sh)"

WSFormat="#[fg=$visual_grey,bg=default]$right_arrow_icon_inverse"
WSFormat="$WSFormat#[fg=#aab2bf,bg=$visual_grey] #I #W #{?#{==:#{pane_current_command},ssh},#[fg=$magenta] ,}"
WSFormat="$WSFormat#[fg=$red]#{?window_bell_flag, ,}"
WSFormat="$WSFormat#[fg=$red]#{?window_activity_flag, ,}"
WSFormat="$WSFormat#[fg=$green]#{?window_zoomed_flag,▣ ,}"
WSFormat="$WSFormat#[fg=$green]#{?window_last_flag, ,}$EndFormat"
WSFormat="$WSFormat#[fg=$visual_grey,bg=default]$right_arrow_icon"

WSCFormat="#[fg=$blue,bg=default]$right_arrow_icon_inverse"
WSCFormat="$WSCFormat#[fg=$black,bg=$blue,bold] #I #W #{?#{==:#{pane_current_command},ssh},#[fg=$magenta] ,}"
WSCFormat="$WSCFormat#[fg=$green]#{?window_zoomed_flag,▣ ,}"
WSCFormat="$WSCFormat#[fg=$green] "
WSCFormat="$WSCFormat#[fg=$blue,bg=default]$right_arrow_icon"

tmux_set window-status-format "$WSFormat"
tmux_set window-status-current-format "$WSCFormat"
tmux_set window-status-bell-style 'blink' # sleep 2 && echo -e "\a"
tmux_set window-status-activity-style 'blink' # ssh 警告

#===========左状态栏===================
#     
# ' 
# https://www.nerdfonts.com/cheat-sheet
session_icon=" "

tmux_set status-left-length 100
tmux_set status-left-style none
# 展示 ssh 红色，yellow 命令模式, green 正常模式, tmux 嵌套蓝色

# 初始化 LS 变量
LS="#[bg=$green] #S $session_icon#[fg=$green,bg=default]$right_arrow_icon"  # 默认绿色背景，之后回归默认背景
LS="#{?#{==:#{pane_current_command},ssh},#[bg=$red] #S $session_icon#[fg=$red]#[bg=default]$right_arrow_icon,$LS}" # SSH 红色，之后回归默认背景
LS="#{?client_prefix,#[bg=$yellow] #S $session_icon#[fg=$yellow]#[bg=default]$right_arrow_icon,$LS}"                # 命令模式黄色，之后回归默认背景
LS="#{?synchronize-panes,#[bg=$yellow] #S $session_icon#[fg=$yellow]#[bg=default]$right_arrow_icon,$LS}"          # 同步窗格黄色，之后回归默认背景
LS="#{?pane_in_mode,#[bg=$yellow] #S $session_icon#[fg=$yellow]#[bg=default]$right_arrow_icon,$LS}"                # Vi 模式黄色，之后回归默认背景
LS="#{?#{==:#{client_key_table},off},#[bg=$blue] #S $session_icon#[fg=$blue]#[bg=default]$right_arrow_icon,$LS}"  # tmux 嵌套模式蓝色，之后回归默认背景
LS="#[fg=$black,bold]$LS"
tmux_set status-left "$LS"

#===========右状态栏===================
time_icon=""
time_format='%T'
download_speed_icon=''
tmux_set status-right-length 150
tmux_set status-right-style none

tmux_set @IM "#(/opt/homebrew/bin/im-select | cut -d "." -f4 | sed -e 's/Squirrel/ZH/' -e 's/ABC/US/' -e 's/SCIM/ZH/')"
tmux_set @download_speed "#(~/.config/tmux/script/net-speed.sh rx_bytes '%%7s')"
# tmux_set @cpu_usage "#(~/.config/tmux/script/cpu_percentage.sh)"
GIT_BRANCH="#(git -C #{pane_current_path} rev-parse --abbrev-ref HEAD)"

gitStatus="#[fg=$blue]$left_arrow_icon#[fg=$BG]#[bg=$blue]#[nobold]  $GIT_BRANCH #[fg=$blue]#[bg=default]$left_arrow_icon_inverse"
sshStatus="#[fg=$red]$left_arrow_icon#[fg=$BG]#[bg=$red]#[nobold] $HOST_NAME #[fg=$red]#[bg=default]$left_arrow_icon_inverse"
viStatus="#[fg=$yellow]$left_arrow_icon#[fg=$BG]#[bg=$yellow]#[bold] VIM #[fg=$yellow]#[bg=default]#[nobold]$left_arrow_icon_inverse"
syncStatus="#[fg=$yellow]$left_arrow_icon#[fg=$BG]#[bg=$yellow]#[bold] SYNC #[fg=$yellow]#[bg=default]#[nobold]$left_arrow_icon_inverse"


inputStatus="#{?#{==:#{E:@IM},ZH},#[fg=$red]$left_arrow_icon#[fg=#aab2bf]#[bg=$red]  #[bold]ZH ,#[fg=$visual_grey]$left_arrow_icon#[fg=#aab2bf]#[bg=$visual_grey]  US }"
timeStatus="#[fg=$visual_grey]$left_arrow_icon#[bg=$visual_grey]#[fg=#aab2bf] $time_icon $time_format #[fg=$visual_grey]#[bg=default]#[nobold]$left_arrow_icon_inverse"
speedStatus="#[fg=$visual_grey]$left_arrow_icon#[bg=$visual_grey]#[fg=#aab2bf] $download_speed_icon#{E:@download_speed} #[fg=$visual_grey]#[bg=default]#[nobold]$left_arrow_icon_inverse"


RS="$speedStatus$timeStatus$inputStatus"
RS="#{?$GIT_BRANCH,$gitStatus,}$RS"
RS="#{?#{==:#{pane_current_command},ssh},$sshStatus,}$RS"
RS="#{?pane_in_mode,$viStatus,}$RS"
RS="#{?synchronize-panes,$syncStatus,}$RS"

tmux_set status-right "$RS"
