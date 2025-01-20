#!/usr/bin/env bash

# $1: option, $2: value
tmux_get() {
    local value="$(tmux show -gqv "$1")"
    [ -n "$value" ] && echo "$value" || echo "$2"
}

# $1: option, $2: value
tmux_set() {
    tmux set-option -gq "$1" "$2"
}
# 使用该方法设置值，tmux 页面会被刷新，shift 选择文本时

# list color
# for i in {0..255}; do
#     printf '\x1b[38;5;%dmcolour%d\x1b[0m ' $i $i
# done

bg="#1A1B26"
fg="#a9b1d6"
black="#414868"
blue="#7aa2f7"
cyan="#7dcfff"
green="#73daca"
magenta="#bb9af7"
red="#f7768e"
white="#c0caf5"
yellow="#e0af68"

bblack="#2A2F41"
bblue="#7aa2f7"
bcyan="#7dcfff"
bgreen="#41a6b5"
bmagenta="#bb9af7"
bred="#ff9e64"
bwhite="#787c99"
byellow="#e0af68"

ghgreen="#3fb950"
ghmagenta="#A371F7"
ghred="#d73a4a"
ghyellow="#d29922"

# https://man7.org/linux/man-pages/man1/tmux.1.html
#==========通用颜色配置=================
# tmux_set popup-border-style "bg=$bg,fg=$fg" # popup 边缘背景色

tmux_set status-style "fg=$fg" # 状态栏样式

tmux_set message-style "fg=$red"          # 消息前景背景色
tmux_set message-command-style "fg=$red"  # 设置状态行消息命令样式

tmux_set pane-border-style "fg=$gray" # 设置面板默认分割线的颜色
tmux_set pane-active-border-style "fg=$green" # 设置活动面板分割线的颜色

tmux_set display-panes-colour "fg=$blue"          # 设置窗格颜色
tmux_set display-panes-active-colour "fg=$yellow" # 设置活动窗格颜色

tmux_set mode-style "bg=$blue" # 设置复制模式下的高亮颜色

tmux_set window-status-separator ""

tmux_set clock-mode-colour "$TC"        # 时钟模式
tmux_set clock-mode-style 24

right_icon='' # e0b0
right_icon_inverse='' # e0d7
left_icon='' # e0b2
left_icon_inverse='' # e0d6

left_separator="" # e0b6
right_separator="" # e0b4
middle_separator="█"

# nobold 禁用粗体，noitalics 禁止倾斜文字 nounderscore 禁用下划线 nodim 禁用暗淡
#==================Windows状态栏=======
iconFormat="#{?#{==:#{pane_current_command},ssh},#[fg=$red] , }"
iconFormat="#{?#{==:#{pane_current_command},nvim},#[fg=$ghgreen]󰕷 ,$iconFormat}"

WSFormat="#[fg=$black,bg=default]$right_icon_inverse"
WSFormat="$WSFormat#[fg=$bwhite,bg=$black] $iconFormat #[fg=$bwhite]#W "
WSFormat="$WSFormat#[fg=$yellow]#{?window_bell_flag,󰂠 ,}"
WSFormat="$WSFormat#[fg=$yellow]#{?window_activity_flag,󰂚 ,}"
WSFormat="$WSFormat#[fg=$green]#{?window_zoomed_flag, ,}"
WSFormat="$WSFormat#[fg=$red]#{?#{==:#{pane_mode},copy-mode}, ,}"
WSFormat="$WSFormat#[fg=$green]#{?window_last_flag, ,}"
WSFormat="$WSFormat#[fg=$black,bg=default]$right_icon"


WSCFormat="#[fg=$bblack,bg=default]$right_icon_inverse"
WSCFormat="$WSCFormat#[fg=$white,bg=$bblack] $iconFormat #[fg=$white]#W "
WSCFormat="$WSCFormat#[fg=$red]#{?#{==:#{pane_mode},copy-mode}, ,}"
WSCFormat="$WSCFormat#[fg=$green]#{?window_zoomed_flag, ,}"
WSCFormat="$WSCFormat#[fg=$green] "
WSCFormat="$WSCFormat#[fg=$bblack,bg=default]$right_icon"

tmux_set window-status-format "$WSFormat"
tmux_set window-status-current-format "$WSCFormat"

tmux_set window-status-bell-style 'blink' # sleep 5 && tmux display-message done
tmux_set window-status-activity-style 'blink' # ssh 警告 sleep 2 && echo -e "\a"

#===========左状态栏===================
#     
# ' 
# https://www.nerdfonts.com/cheat-sheet
session_icon=""

tmux_set status-left-length 0
tmux_set status-left-style none

LS="#{?#{==:#{pane_current_command},ssh},#[fg=$red]󰅡 ,󰤂 }" # SSH
LS="#{?client_prefix,#[fg=$yellow]󰠠 ,$LS}"                 # 命令模式
LS="#{?synchronize-panes,#[fg=$magenta]󱍸 ,$LS}"            # 同步窗格
LS="#{?pane_in_mode,#[fg=$red]󰗦 ,$LS}"                   # Vi 模式
LS="#[fg=$bblack,bg=$blue,bold,nodim] $LS#[fg=$bblack,bg=$blue,bold,nodim]#S #[fg=$blue,bg=default]$right_icon"

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
HOST_NAME="#(~/.config/tmux/script/hostname.sh)"

gitStatus="#[fg=$blue]$left_separator#[fg=$black]#[bg=$blue] $GIT_BRANCH#[fg=$blue]#[bg=default]$right_separator"
sshStatus="#[fg=$red]$left_separator#[fg=$black]#[bg=$red] $HOST_NAME#[fg=$red]#[bg=default]$right_separator"
viStatus="#[fg=$green]$left_separator#[fg=$black]#[bg=$green]  #[fg=$green]#[bg=default]#[nobold]$right_separator"
syncStatus="#[fg=$yellow]$left_separator#[fg=$black]#[bg=$yellow]  #[fg=$yellow]#[bg=default]#[nobold]$right_separator"
prefixStatus="#[fg=$yellow]$left_separator#[fg=$black]#[bg=$yellow] 󰘳 #[fg=$yellow]#[bg=default]$right_separator"
# inputStatus="#[fg=$red]$left_separator#[fg=$black]#[bg=$red] 󰗊 #[fg=$red]#[bg=default]$right_separator"


timeStatus="#[fg=$blue]$left_separator#[bg=$blue]#[fg=$bg]$time_icon $time_format#[fg=$blue]#[bg=default]$right_separator"
speedStatus="#[fg=$cyan]$left_separator#[bg=$cyan]#[fg=$bg]$download_speed_icon#{E:@download_speed}#[fg=$cyan]#[bg=default]$right_separator"

RS="$speedStatus $timeStatus"
RS="#{?$GIT_BRANCH,$gitStatus ,}$RS"
# RS="#{?#{==:#{pane_current_command},ssh},$sshStatus ,}$RS"
RS="#{?pane_in_mode,$viStatus ,}$RS"
RS="#{?synchronize-panes,$syncStatus ,}$RS"
# RS="#{?#{==:#{E:@IM},ZH},$inputStatus ,}$RS"
RS="#{?client_prefix,$prefixStatus ,}$RS"

tmux_set status-right "$RS"
