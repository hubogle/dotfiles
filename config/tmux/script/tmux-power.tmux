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

TC=$(tmux_get '@tmux_power_theme' 'onedark')
case $TC in
    'gold' )
        TC='#ffb86c'
        ;;
    'redwine' )
        TC='#b34a47'
        ;;
    'moon' )
        TC='#00abab'
        ;;
    'forest' )
        TC='#228b22'
        ;;
    'violet' )
        TC='#9370db'
        ;;
    'snow' )
        TC='#fffafa'
        ;;
    'coral' )
        TC='#ff7f50'
        ;;
    'sky' )
        TC='#87ceeb'
        ;;
    'onedark' )
        TC='#aab2bf'
        ;;
    'default' ) # Useful when your term changes colour dynamically (e.g. pywal)
        TC='colour3'
        ;;
esac

G01=#080808 #232
G02=#121212 #233
G03=#1c1c1c #234
G04=#262626 #235
G05=#303030 #236
G06=#3a3a3a #237
G07=#444444 #238
G08=#4e4e4e #239
G09=#585858 #240
G10=#626262 #241
G11=#6c6c6c #242
G12=#767676 #243
onedark_black="#282c34"
onedark_blue="#61afef"
onedark_yellow="#e5c07b"
onedark_red="#e06c75"
onedark_white="#aab2bf"
onedark_green="#98c379"
onedark_visual_grey="#3e4452"
onedark_comment_grey="#5c6370"

FG="$onedark_white"  # 前景色
BG="$onedark_black"  # 背景色


right_arrow_icon=''
left_arrow_icon=''

#==========通用颜色配置=================
tmux_set status-style "fg=$FG,bg=$BG" # 状态栏样式

tmux_set message-style "fg=$FG,bg=$BG"          # 消息前景背景色
tmux_set message-command-style "fg=$FG,bg=$BG"  # 设置状态行消息命令样式

tmux_set pane-border-style "fg=$FG,bg=$BG" # 设置面板默认分割线的颜色
tmux_set pane-active-border-style "fg=$onedark_green,bg=$BG" # 设置活动面板分割线的颜色

tmux_set display-panes-colour "$onedark_blue"          # 设置窗格颜色
tmux_set display-panes-active-colour "$onedark_yellow" # 设置活动窗格颜色

tmux_set mode-style "bg=#202529,fg=#91A8BA" # 设置复制模式下的高亮颜色

tmux_set window-status-separator ""

tmux_set clock-mode-colour "$TC"        # 时钟模式
tmux_set clock-mode-style 24

#==================Windows状态栏=======
HOST_NAME="#(~/.config/tmux/script/hostname.sh)"

StartFormat="#[fg=$BG,bg=$onedark_visual_grey,nobold,noitalics,nounderscore]$right_arrow_icon"
EndFormat="$WSFormat#[fg=$onedark_visual_grey,bg=$BG,nobold,noitalics,nounderscore]$right_arrow_icon"

WSFormat="$StartFormat #{?#{==:#{pane_current_command},ssh},#[fg=$onedark_red]#I #W  ,#[fg=$FG]#I #W }"
WSFormat="$WSFormat#[fg=$onedark_red]#{?window_bell_flag, ,}"
WSFormat="$WSFormat#[fg=$onedark_red]#{?window_activity_flag, ,}"
WSFormat="$WSFormat#[fg=$onedark_green]#{?window_last_flag, ,}"
WSFormat="$WSFormat#[fg=$onedark_green]#{?window_zoomed_flag, ,}$EndFormat"

WSCFormat="#[fg=$BG,bg=cyan,nobold,noitalics,nounderscore]$right_arrow_icon"
# WSCFormat="$WSCFormat#[fg=$BG] #I #W "
WSCFormat="$WSCFormat#{?#{==:#{pane_current_command},ssh},#[fg=$BG]#[bold] #I $HOST_NAME #[fg=$onedark_green] ,#[fg=$BG]#[bold] #I #W }"
# WSCFormat="$WSCFormat#[fg=$onedark_green]#{?#{==:#{pane_current_command},ssh}, ,}"
WSCFormat="$WSCFormat#[fg=$onedark_green]#{?window_zoomed_flag, ,}"
WSCFormat="$WSCFormat#[fg=$onedark_green] "
WSCFormat="$WSCFormat#[fg=cyan,bg=$BG,nobold,noitalics,nounderscore]$right_arrow_icon"

tmux_set window-status-format "$WSFormat"
tmux_set window-status-current-format "$WSCFormat"
tmux_set window-status-bell-style 'blink' # sleep 2 && echo -e "\a"
tmux_set window-status-activity-style 'blink' # ssh 警告

#===========左状态栏===================
#     
# ' 
# https://www.nerdfonts.com/cheat-sheet
session_icon="﬿ "

tmux_set status-left-length 100
tmux_set status-left-style none
# 展示 ssh 红色，yellow 命令模式, green 正常模式
statusBase="#{?#{==:#{pane_current_command},ssh},#[bg=$onedark_red] #S $session_icon#[fg=$onedark_red]#[bg=$BG],#[bg=$onedark_green] #S $session_icon#[fg=$onedark_green]#[bg=$BG]}"
tmux_set status-left "#[fg=$BG]#{?client_prefix,#[bg=$onedark_yellow] #S $session_icon#[fg=$onedark_yellow]#[bg=$BG],$statusBase}"

#===========右状态栏===================
time_icon=""
date_icon="'"
time_format='%T'
date_format='%F'
upload_speed_icon=''
download_speed_icon=''
tmux_set status-right-length 150
tmux_set status-right-style none

# tmux_set @IM "  #(/opt/homebrew/bin/im-select | cut -d "." -f4 | sed -e 's/Squirrel/ZH/' -e 's/ABC/US/' -e 's/SCIM/ZH/')"

tmux_set @download_speed "#(~/.config/tmux/script/net-speed.sh rx_bytes '%%7s')"
GIT_BRANCH="#(git -C #{pane_current_path} rev-parse --abbrev-ref HEAD)"

viCopyStatus="#[fg=$onedark_yellow]#[bg=$BG]#[fg=$BG]#[bg=$onedark_yellow] COPY #[fg=$BG]#[bg=$onedark_yellow]#[fg=$BG]"
syncStatus="#[fg=$onedark_yellow]#[bg=$BG]#[fg=$BG]#[bg=$onedark_yellow] SYNC #[fg=$BG]#[bg=$onedark_yellow]#[fg=$BG]"
gitStatus="#[fg=cyan]#[bg=$BG]#[fg=$BG]#[bg=cyan]  $GIT_BRANCH #[fg=$BG]#[bg=cyan]#[fg=$BG]"
sshStatus="#[fg=$onedark_red]#[bg=$BG]#[fg=$BG]#[bg=$onedark_red] $HOST_NAME "
localStatus="#[fg=$onedark_green]#[bg=$BG]#[fg=$BG]#[bg=$onedark_green] #H "

# RS="#[fg=$onedark_green,bg=$BG]#[fg=$BG,bg=$onedark_green]#{E:@IM} "

RS="#{?#{==:#{pane_current_command},ssh},$sshStatus,$localStatus}"
RS="#[fg=$FG,bg=$BG] $date_icon $date_format#[fg=$BG,bg=$BG]$RS"
RS="#[fg=$FG,bg=$BG] $time_icon $time_format#[fg=$BG]$RS"
RS="#[fg=$FG,bg=$BG] $download_speed_icon #{E:@download_speed} $RS" # 网络速度
RS="#{?$GIT_BRANCH,$gitStatus,}$RS"
RS="#{?pane_in_mode,$viCopyStatus,}$RS"
RS="#{?synchronize-panes,$syncStatus,}$RS"

tmux_set status-right "$RS"
