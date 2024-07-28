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

red="colour196"
green="#8cc265"

# https://github.com/catppuccin/tmux
bg="#24273a"
fg="#cad3f5"
gray="#363a4f"
yellow="#eed49f"
magenta="#c6a0f6"
orange="#f5a97f"
blue="#8aadf4"
black="#1e2030"
cyan="#91d7e3"
# red="#ed8796"
# green="#a6da95"
pink="#f5bde6"
# black4="#5b6078"


right_arrow_icon='' # e0b0
right_arrow_icon_inverse='' # e0d7
left_arrow_icon='' # e0b2
left_arrow_icon_inverse='' # e0d6

left_separator="" # e0b6
right_separator="" # e0b4
middle_separator="█"

# https://man7.org/linux/man-pages/man1/tmux.1.html
#==========通用颜色配置=================
# tmux_set popup-border-style "bg=$bg,fg=$fg" # popup 边缘背景色

tmux_set status-style "fg=$fg" # 状态栏样式

tmux_set message-style "fg=$cyan"          # 消息前景背景色
tmux_set message-command-style "fg=$cyan"  # 设置状态行消息命令样式

tmux_set pane-border-style "fg=$gray" # 设置面板默认分割线的颜色
tmux_set pane-active-border-style "fg=$green" # 设置活动面板分割线的颜色

tmux_set display-panes-colour "fg=$blue"          # 设置窗格颜色
tmux_set display-panes-active-colour "fg=$yellow" # 设置活动窗格颜色

tmux_set mode-style "bg=$gray,fg=$pink" # 设置复制模式下的高亮颜色

tmux_set window-status-separator ""

tmux_set clock-mode-colour "$TC"        # 时钟模式
tmux_set clock-mode-style 24

# nobold 禁用粗体，noitalics 禁止倾斜文字 nounderscore 禁用下划线
#==================Windows状态栏=======
HOST_NAME="#(~/.config/tmux/script/hostname.sh)"

WSFormat="#[fg=$blue,bg=default]$left_separator#[fg=$bg,bg=$blue,bold]#I#[nobold]#[fg=$blue]$middle_separator"
WSFormat="$WSFormat#[fg=$fg,bg=$gray] #W #{?#{==:#{pane_current_command},ssh},#[fg=magenta] ,}"
WSFormat="$WSFormat#[fg=$red]#{?window_bell_flag, ,}"
WSFormat="$WSFormat#[fg=$green]#{?window_activity_flag,󰂚 ,}"
WSFormat="$WSFormat#[fg=$green]#{?window_zoomed_flag, ,}"
WSFormat="$WSFormat#[fg=$green]#{?window_last_flag, ,}$EndFormat"
WSFormat="$WSFormat#[fg=$gray,bg=default]$right_separator "

WSCFormat="#[fg=$orange,bg=default]$left_separator#[fg=$bg,bg=$orange,bold]#I#[nobold]#[fg=$orange]$middle_separator"
WSCFormat="$WSCFormat#[fg=$fg,bg=$bg] #W #{?#{==:#{pane_current_command},ssh},#[fg=magenta] ,}"
WSCFormat="$WSCFormat#[fg=$green]#{?window_zoomed_flag, ,}"
WSCFormat="$WSCFormat#[fg=$green] "
WSCFormat="$WSCFormat#[fg=$bg,bg=default]$right_separator "

tmux_set window-status-format "$WSFormat"
tmux_set window-status-current-format "$WSCFormat"
tmux_set window-status-bell-style 'blink' # sleep 5 && tmux display-message done
tmux_set window-status-activity-style 'blink' # ssh 警告 sleep 2 && echo -e "\a"

#===========左状态栏===================
#     
# ' 
# https://www.nerdfonts.com/cheat-sheet
session_icon=" "

tmux_set status-left-length 0
tmux_set status-left-style none
# 展示 ssh 红色，$yellow 命令模式, $green 正常模式, tmux 嵌套蓝色

# 初始化 LS 变量
# LS="#[bg=$green]#[bold] #S #[nobold]$session_icon#[fg=$green,bg=default]$right_arrow_icon"  # 默认绿色背景，之后回归默认背景
# LS="#{?#{==:#{pane_current_command},ssh},#[bg=$red]#[bold] #S #[nobold]$session_icon#[fg=$red]#[bg=default]$right_arrow_icon,$LS}" # SSH 红色，之后回归默认背景
# LS="#{?client_prefix,#[bg=$yellow]#[bold] #S #[nobold]$session_icon#[fg=$yellow]#[bg=default]$right_arrow_icon,$LS}"                # 命令模式黄色，之后回归默认背景
# LS="#{?synchronize-panes,#[bg=$yellow]#[bold] #S #[nobold]$session_icon#[fg=$yellow]#[bg=default]$right_arrow_icon,$LS}"          # 同步窗格黄色，之后回归默认背景
# LS="#{?pane_in_mode,#[bg=$yellow]#[bold] #S #[nobold]$session_icon#[fg=$yellow]#[bg=default]$right_arrow_icon,$LS}"                # Vi 模式黄色，之后回归默认背景
# LS="#{?#{==:#{client_key_table},off},#[bg=$blue]#[bold] #S #[nobold]$session_icon#[fg=$blue]#[bg=default]$right_arrow_icon,$LS}"  # tmux 嵌套模式蓝色，之后回归默认背景
# LS="#[fg=$black]$LS"
tmux_set status-left ""

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

gitStatus="#[fg=$blue]$left_separator#[fg=$black]#[bg=$blue] $GIT_BRANCH#[fg=$blue]#[bg=default]$right_separator"
sshStatus="#[fg=$red]$left_separator#[fg=$black]#[bg=$red] $HOST_NAME#[fg=$red]#[bg=default]$right_separator"
viStatus="#[fg=$green]$left_separator#[fg=$black]#[bg=$green]  #[fg=$green]#[bg=default]#[nobold]$right_separator"
syncStatus="#[fg=$yellow]$left_separator#[fg=$black]#[bg=$yellow]  #[fg=$yellow]#[bg=default]#[nobold]$right_separator"
prefixStatus="#[fg=$red]$left_separator#[fg=$black]#[bg=$red] 󰘳 #[fg=$red]#[bg=default]$right_separator"
inputStatus="#[fg=$red]$left_separator#[fg=$black]#[bg=$red] 󰗊 #[fg=$red]#[bg=default]$right_separator"


# inputStatus="#{?#{==:#{E:@IM},ZH},#[fg=$red]$left_arrow_icon#[fg=$black]#[bg=$red]  #[bold]ZH ,#[fg=$gray]$left_arrow_icon#[fg=$font_color]#[bg=$gray]  US }"
timeStatus="#[fg=$blue]$left_separator#[bg=$blue]#[fg=$bg]$time_icon $time_format#[fg=$blue]#[bg=default]$right_separator"
speedStatus="#[fg=$cyan]$left_separator#[bg=$cyan]#[fg=$bg]$download_speed_icon#{E:@download_speed}#[fg=$cyan]#[bg=default]$right_separator"

RS="$speedStatus $timeStatus"
RS="#{?$GIT_BRANCH,$gitStatus ,}$RS"
RS="#{?#{==:#{pane_current_command},ssh},$sshStatus ,}$RS"
RS="#{?pane_in_mode,$viStatus ,}$RS"
RS="#{?synchronize-panes,$syncStatus ,}$RS"
RS="#{?#{==:#{E:@IM},ZH},$inputStatus ,}$RS"
RS="#{?client_prefix,$prefixStatus ,}$RS"

tmux_set status-right "$RS"
