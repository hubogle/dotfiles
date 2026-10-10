#!/usr/bin/env bash
tmux_set() {
  tmux set-option -gq "$1" "$2"
}

#---------------------- 通用样式 ------------------------------
# ANSI 颜色名引用终端调色板，terminal 使用终端默认前景或背景。
tmux_set status-style                 "fg=terminal,bg=terminal"
tmux_set message-style                "fg=red,bg=terminal,fill=terminal,width=50%,align=left"  # 消息铺满状态栏左半，右侧状态保持可见
tmux_set message-command-style        "fg=red,bg=terminal,fill=terminal"      # 命令提示符铺满整行
tmux_set popup-style                  "fg=terminal,bg=terminal"
tmux_set popup-border-style           "fg=brightblack,bg=terminal"
tmux_set menu-style                   "fg=terminal,bg=terminal"
tmux_set menu-border-style            "fg=brightblack,bg=terminal"
tmux_set menu-selected-style          "fg=black,bg=blue"
tmux_set copy-mode-line-number-style          "fg=terminal"
tmux_set copy-mode-current-line-number-style  "fg=yellow,bold"
# 显式设置前景，避免浅色主题的默认深色文字落在 ANSI 深色背景上。
tmux_set copy-mode-current-line-style         "fg=brightwhite,bg=brightblack"
tmux_set pane-border-style            "fg=brightblack"
tmux_set pane-active-border-style     "fg=green"
tmux_set pane-scrollbars-style        "fg=white,bg=brightblack,width=1,pad=0"
tmux_set display-panes-colour         "blue"
tmux_set display-panes-active-colour  "yellow"
tmux_set mode-style                   "fg=black,bg=blue"
tmux_set window-status-separator      ""
tmux_set clock-mode-colour            "blue"
tmux_set clock-mode-style             24

#---------------------- 符号与分隔符 --------------------------
# https://www.nerdfonts.com/cheat-sheet
RIGHT_ICON=''
RIGHT_ICON_INVERSE=''
LEFT_ICON=''
LEFT_ICON_INVERSE=''
LEFT_SEP=""
RIGHT_SEP=""

#---------------------- 窗口图标逻辑 --------------------------
# 根据命令/模式选择不同图标颜色
ICON_FORMAT="#{?#{==:#{pane_current_command},ssh},#[fg=red] , }"
ICON_FORMAT="#{?#{==:#{pane_current_command},nvim},#[fg=green]󰕷 ,$ICON_FORMAT}"
ICON_FORMAT="#{?#{==:#{pane_mode},copy-mode},#[fg=green]󰕷 ,$ICON_FORMAT}"

#---------------------- Windows 状态栏 ------------------------
# 非当前窗口
WS_FORMAT=""
WS_FORMAT+="#[fg=black,bg=terminal]$RIGHT_ICON_INVERSE"
WS_FORMAT+="#[fg=white,bg=black] $ICON_FORMAT#[fg=white]#W "
WS_FORMAT+="#[fg=red]#{?pane_in_mode, ,}"
WS_FORMAT+="#[fg=yellow]#{?window_bell_flag,󰂠 ,}"
WS_FORMAT+="#[fg=yellow]#{?window_activity_flag,󰂚 ,}"
WS_FORMAT+="#[fg=brightgreen]#{?window_zoomed_flag, ,}"
WS_FORMAT+="#[fg=brightgreen]#{?window_last_flag, ,}"
WS_FORMAT+="#[fg=black,bg=terminal]$RIGHT_ICON"

# 当前窗口
WSC_FORMAT=""
WSC_FORMAT+="#[fg=brightblack,bg=terminal]$RIGHT_ICON_INVERSE"
WSC_FORMAT+="#[fg=brightwhite,bg=brightblack] $ICON_FORMAT#[fg=brightwhite]#W "
WSC_FORMAT+="#[fg=red]#{?pane_in_mode, ,}"
WSC_FORMAT+="#[fg=brightgreen]#{?window_zoomed_flag, ,}"
WSC_FORMAT+="#[fg=brightgreen] "
WSC_FORMAT+="#[fg=brightblack,bg=terminal]$RIGHT_ICON"

tmux_set window-status-format          "$WS_FORMAT"
tmux_set window-status-current-format  "$WSC_FORMAT"
tmux_set window-status-current-style   "default"
tmux_set window-status-bell-style      "blink"
tmux_set window-status-activity-style  "blink"

#---------------------- 左状态栏 ------------------------------
tmux_set status-left-length 0
tmux_set status-left-style none

LS_ICON="#{?#{==:#{pane_current_command},ssh},#[fg=red]󰅡 ,󰤂 }"
LS_ICON="#{?client_prefix,#[fg=yellow]󰠠 ,$LS_ICON}"
LS_ICON="#{?synchronize-panes,#[fg=green]󱍸 ,$LS_ICON}"
LS_ICON="#{?pane_in_mode,#[fg=red]󰗦 ,$LS_ICON}"

STATUS_LEFT=""
STATUS_LEFT+="#[fg=black,bg=blue,bold,nodim]  "
STATUS_LEFT+="#[fg=black,bg=blue,bold,nodim]#S "
STATUS_LEFT+="#[fg=blue,bg=terminal]$RIGHT_ICON"

tmux_set status-left "$STATUS_LEFT"

#---------------------- 右状态栏 - 图标与格式 -----------------
TIME_ICON="󰔟"
TIME_FORMAT='%T'
DOWNLOAD_ICON='󰄼'
CPU_ICON=' '
SSH_ICON=" "

tmux_set status-right-length 150
tmux_set status-right-style none

# tmux_set @IM              "#(/opt/homebrew/bin/im-select | cut -d '.' -f4 | sed -e 's/Squirrel/ZH/' -e 's/ABC/US/' -e 's/SCIM/ZH/')"
tmux_set @download_speed  "#(~/.config/tmux/script/net-speed.sh)"
tmux_set @cpu_usage       "#(~/.config/tmux/script/cpu-usage.sh)"
tmux_set @ssh_host        "#(~/.config/tmux/script/ssh-host.sh #{pane_pid})"

GIT_BRANCH="#(git -C #{pane_current_path} rev-parse --abbrev-ref HEAD)"

#---------------------- 右侧各块（右→左） -----------------------
SEG_TIME="#[fg=blue]#[bg=terminal]$LEFT_SEP#[fg=black]#[bg=blue]$TIME_ICON #[bg=terminal]#[fg=terminal] $TIME_FORMAT "
SEG_SPEED="#[fg=cyan]#[bg=terminal]$LEFT_SEP#[fg=black]#[bg=cyan]$DOWNLOAD_ICON #[bg=terminal]#[fg=terminal]#{E:@download_speed}"
SEG_CPU="#[fg=cyan]#[bg=terminal]$LEFT_SEP#[fg=black]#[bg=cyan]$CPU_ICON#[bg=terminal]#[fg=terminal] #{E:@cpu_usage}"
SEG_GIT="#[fg=green]#[bg=terminal]$LEFT_SEP#[fg=black]#[bg=green] #[bg=terminal]#[fg=terminal] $GIT_BRANCH"
SEG_SSH="#[fg=red]#[bg=terminal]$LEFT_SEP#[fg=black]#[bg=red]$SSH_ICON#[bg=terminal]#[fg=terminal] #{E:@ssh_host} "

# 状态标记块
SEG_SYNC="#[fg=yellow]#[bg=terminal]$LEFT_SEP#[fg=black]#[bg=yellow]󰓦 #[bg=terminal]#[fg=terminal] SYNC"
SEG_VI="#[fg=green]#[bg=terminal]$LEFT_SEP#[fg=black]#[bg=green] #[bg=terminal]#[fg=terminal] COPY"
SEG_PREFIX="#[fg=yellow]#[bg=terminal] 󰘳 "

# 右侧最终拼接（条件 + 信息块）
STATUS_RIGHT="$SEG_SPEED $SEG_CPU $SEG_TIME"
STATUS_RIGHT="#{?#{==:#{pane_current_command},ssh},$SEG_SSH,}$STATUS_RIGHT"
STATUS_RIGHT="#{?$GIT_BRANCH,$SEG_GIT ,}$STATUS_RIGHT"
STATUS_RIGHT="#{?synchronize-panes,$SEG_SYNC ,}$STATUS_RIGHT"
STATUS_RIGHT="#{?pane_in_mode,$SEG_VI ,}$STATUS_RIGHT"
STATUS_RIGHT="#{?client_prefix,$SEG_PREFIX ,}$STATUS_RIGHT"

tmux_set status-right "$STATUS_RIGHT"
