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

# Options
right_arrow_icon=''
left_arrow_icon=''
upload_speed_icon=''
download_speed_icon=''
show_upload_speed="$(tmux_get @tmux_power_show_upload_speed false)"
show_download_speed="$(tmux_get @tmux_power_show_download_speed false)"
show_web_reachable="$(tmux_get @tmux_power_show_web_reachable false)"
prefix_highlight_pos=$(tmux_get @tmux_power_prefix_highlight_pos)
# short for Theme-Colour
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

#==========通用颜色配置=================
tmux_set status-fg "$FG"    # 状态栏背景色
tmux_set status-bg "$BG"    # 状态栏前景色
tmux_set status-attr none

tmux_set message-style "fg=$FG,bg=$BG"          # 消息前景背景色
tmux_set message-command-style "fg=$FG,bg=$BG"  # 设置状态行消息命令样式

set -g window-style "fg=$onedark_comment_grey" # 设置窗口样式
set -g window-active-style "fg=$onedark_white" # 设置活动窗口样式

set -g window-status-style "bg=$onedark_black, fg=$onedark_white" # 设置窗口状态样式
set -g window-status-activity-style "bg=$onedark_black, fg=$onedark_white" # 设置活动窗口状态样式
tmux_set window-status-current-statys "fg=$TC,bg=$BG" # 设置当前活动窗口的状态栏样式

tmux_set pane-border-style "fg=$FG,bg=$BG" # 设置面板默认分割线的颜色
tmux_set pane-active-border-style "fg=$onedark_green,bg=$BG" # 设置活动面板分割线的颜色

tmux_set display-panes-colour "$onedark_blue"          # 设置窗格颜色
tmux_set display-panes-active-colour "$onedark_yellow" # 设置活动窗格颜色

tmux_set mode-style "bg=#202529,fg=#91A8BA" # 设置复制模式下的高亮颜色

tmux_set window-status-format " #I:#W#F "
tmux_set window-status-current-format "#[fg=$BG,bg=$G06]$right_arrow_icon#[fg=$TC,bold] #I:#W#F #[fg=$G06,bg=$BG,nobold]$right_arrow_icon"

tmux_set clock-mode-colour "$TC"        # 时钟模式
tmux_set clock-mode-style 24

#===========左状态栏===================
#     

user_icon=''
session_icon="'"
LS="#[fg=$onedark_black,bg=$onedark_green,bold] $session_icon#S "
tmux_set status-left "$LS"

#===========右状态栏===================
# Right side of status bar
# tmux_set status-right-bg "$BG"
# tmux_set status-right-fg "G12"
# tmux_set status-right-length 150

time_icon=""
date_icon="'"
time_format='%T'
date_format='%F'

RS="#[fg=$G06]$left_arrow_icon#[fg=$TC,bg=$G06] $time_icon $time_format #[fg=$TC,bg=$G06]$left_arrow_icon#[fg=$G04,bg=$TC] $date_icon $date_format "

if "$show_download_speed"; then
    RS="#[fg=$G05,bg=$BG]$left_arrow_icon#[fg=$TC,bg=$G05] $download_speed_icon #{download_speed} $RS"
fi
if "$show_web_reachable"; then
    RS=" #{web_reachable_status} $RS"
fi

RS="#{prefix_highlight}$RS"  # 高亮插件
tmux_set status-right "$RS"

#===========配置高亮插件命令行===============
# tmux-prefix-highlight
tmux_set @prefix_highlight_fg "$BG"
tmux_set @prefix_highlight_bg "$FG"
tmux_set @prefix_highlight_show_copy_mode 'on'
tmux_set @prefix_highlight_copy_mode_attr "fg=$TC,bg=$BG,bold"
tmux_set @prefix_highlight_output_prefix "#[fg=$TC]#[bg=$BG]$left_arrow_icon#[bg=$TC]#[fg=$BG]"
tmux_set @prefix_highlight_output_suffix "#[fg=$TC]#[bg=$BG]$right_arrow_icon"
