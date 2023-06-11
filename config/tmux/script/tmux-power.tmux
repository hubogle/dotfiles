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


right_arrow_icon=''
left_arrow_icon=''

# https://man7.org/linux/man-pages/man1/tmux.1.html
#==========通用颜色配置=================
# tmux_set popup-border-style "bg=$BG,fg=$BG" # popup 边缘背景色

tmux_set status-style "fg=$FG,bg=$BG" # 状态栏样式

tmux_set message-style "fg=$FG,bg=$BG"          # 消息前景背景色
tmux_set message-command-style "fg=$FG,bg=$BG"  # 设置状态行消息命令样式

tmux_set pane-border-style "fg=$FG,bg=$BG" # 设置面板默认分割线的颜色
tmux_set pane-active-border-style "fg=$green,bg=$BG" # 设置活动面板分割线的颜色

tmux_set display-panes-colour "$blue"          # 设置窗格颜色
tmux_set display-panes-active-colour "$yellow" # 设置活动窗格颜色

tmux_set mode-style "bg=#202529,fg=#91A8BA" # 设置复制模式下的高亮颜色

tmux_set window-status-separator ""

tmux_set clock-mode-colour "$TC"        # 时钟模式
tmux_set clock-mode-style 24

#==================Windows状态栏=======
HOST_NAME="#(~/.config/tmux/script/hostname.sh)"

StartFormat="#[fg=$BG,bg=$visual_grey,nobold,noitalics,nounderscore]$right_arrow_icon"
EndFormat="$WSFormat#[fg=$visual_grey,bg=$BG,nobold,noitalics,nounderscore]$right_arrow_icon"

WSFormat="$StartFormat #[fg=#aab2bf]#I #W #{?#{==:#{pane_current_command},ssh},#[fg=$magenta] ,}"
WSFormat="$WSFormat#[fg=$red]#{?window_bell_flag, ,}"
WSFormat="$WSFormat#[fg=$red]#{?window_activity_flag, ,}"
WSFormat="$WSFormat#[fg=$green]#{?window_zoomed_flag, ,}"
WSFormat="$WSFormat#[fg=$green]#{?window_last_flag, ,}$EndFormat"

WSCFormat="#[fg=$BG,bg=$blue,nobold,noitalics,nounderscore]$right_arrow_icon"
WSCFormat="$WSCFormat#{?#{==:#{pane_current_command},ssh},#[fg=$BG]#[bold] #I #W #[fg=$magenta] ,#[fg=$BG]#[bold] #I #W }"
WSCFormat="$WSCFormat#[fg=$green]#{?window_zoomed_flag, ,}"
WSCFormat="$WSCFormat#[fg=$green] "
WSCFormat="$WSCFormat#[fg=$blue,bg=$BG,nobold,noitalics,nounderscore]$right_arrow_icon"

tmux_set window-status-format "$WSFormat"
tmux_set window-status-current-format "$WSCFormat"
tmux_set window-status-bell-style 'blink' # sleep 2 && echo -e "\a"
tmux_set window-status-activity-style 'blink' # ssh 警告

#===========左状态栏===================
#     
# ' 
# https://www.nerdfonts.com/cheat-sheet
session_icon="'"

tmux_set status-left-length 100
tmux_set status-left-style none
# 展示 ssh 红色，yellow 命令模式, green 正常模式

LS="#[bg=$green] #S $session_icon#[fg=$green]#[bg=$BG]" # 正常模式
LS="#{?#{==:#{pane_current_command},ssh},#[bg=$red] #S $session_icon#[fg=$red]#[bg=$BG],$LS}" # ssh 红色
LS="#{?client_prefix,#[bg=$yellow] #S $session_icon#[fg=$yellow]#[bg=$BG],$LS}" # 命令模式 yellow
LS="#{?synchronize-panes,#[bg=$yellow] #S $session_icon#[fg=$yellow]#[bg=$BG],$LS}" # sync 模式
LS="#[fg=$BG,bold]#{?pane_in_mode,#[bg=$yellow] #S $session_icon#[fg=$yellow]#[bg=$BG],$LS}" # vi 模式
tmux_set status-left "$LS"

#===========右状态栏===================
time_icon=""
date_icon="'"
time_format='%T'
date_format='%F'
upload_speed_icon=''
download_speed_icon=''
cpu_low_icon='='
tmux_set status-right-length 150
tmux_set status-right-style none

# tmux_set @IM "  #(/opt/homebrew/bin/im-select | cut -d "." -f4 | sed -e 's/Squirrel/ZH/' -e 's/ABC/US/' -e 's/SCIM/ZH/')"
tmux_set @download_speed "#(~/.config/tmux/script/net-speed.sh rx_bytes '%%7s')"
# tmux_set @cpu_usage "#(~/.config/tmux/script/cpu_percentage.sh)"
GIT_BRANCH="#(git -C #{pane_current_path} rev-parse --abbrev-ref HEAD)"

viStatus="#[fg=$yellow]#[bg=$BG]#[fg=$BG]#[bg=$yellow]#[bold] VIM #[fg=$BG]#[bg=$yellow]#[fg=$BG]"
syncStatus="#[fg=$yellow]#[bg=$BG]#[fg=$BG]#[bg=$yellow]#[bold] SYNC #[fg=$BG]#[bg=$yellow]#[fg=$BG]"
gitStatus="#[fg=$blue]#[bg=$BG]#[fg=$BG]#[bg=$blue]#[bold]  $GIT_BRANCH #[fg=$BG]#[bg=$blue]#[fg=$BG]"
sshStatus="#[fg=$red]#[bg=$BG]#[fg=$BG]#[bg=$red]#[bold] $HOST_NAME #[fg=$BG]#[bg=$red]#[fg=$BG]"
localStatus="#[fg=$green]#[bg=$BG]#[fg=$BG]#[bg=$green]#[bold] #H "

# RS="#[fg=$green,bg=$BG]#[fg=$BG,bg=$green]#{E:@IM} "
# RS="#{?#{==:#{pane_current_command},ssh},$sshStatus,$localStatus}"
RS="#[fg=#aab2bf,bg=$BG] $date_icon$date_format "
RS="#[fg=#aab2bf,bg=$BG] $time_icon $time_format $RS"
# RS="#[fg=#aab2bf,bg=$BG] $cpu_low_icon #{E:@cpu_usage} $RS" # 网络速度
RS="#[fg=#aab2bf,bg=$BG,nobold] $download_speed_icon #{E:@download_speed} $RS" # 网络速度
RS="#{?$GIT_BRANCH,$gitStatus,}$RS"
RS="#{?#{==:#{pane_current_command},ssh},$sshStatus,}$RS"
RS="#{?pane_in_mode,$viStatus,}$RS"
RS="#{?synchronize-panes,$syncStatus,}$RS"

tmux_set status-right "$RS"
