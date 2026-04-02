#!/usr/bin/env bash
tmux_set() {
  tmux set-option -gq "$1" "$2"
}

tmux_set @c-bg      "#1A1B26"
tmux_set @c-fg      "#a9b1d6"

tmux_set @c-black   "#414868"
tmux_set @c-blue    "#7aa2f7"
tmux_set @c-cyan    "#7dcfff"
tmux_set @c-green   "#73daca"
tmux_set @c-red     "#f7768e"
tmux_set @c-white   "#c0caf5"
tmux_set @c-yellow  "#e0af68"

tmux_set @c-bblack  "#2A2F41"
tmux_set @c-bwhite  "#787c99"
tmux_set @c-gray    "#414868"

tmux_set @c-ghgreen "#3fb950"

#---------------------- 通用样式 ------------------------------
tmux_set status-style                 "fg=#{@c-fg}"
tmux_set message-style                "fg=#{@c-red}"
tmux_set message-command-style        "fg=#{@c-red}"
tmux_set pane-border-style            "fg=#{@c-gray}"
tmux_set pane-active-border-style     "fg=#{@c-green}"
tmux_set display-panes-colour         "fg=#{@c-blue}"
tmux_set display-panes-active-colour  "fg=#{@c-yellow}"
tmux_set mode-style                   "bg=default,fg=colour244"
tmux_set window-status-separator      ""
tmux_set clock-mode-colour            "#{@c-blue}"
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
ICON_FORMAT="#{?#{==:#{pane_current_command},ssh},#[fg=#{@c-red}] , }"
ICON_FORMAT="#{?#{==:#{pane_current_command},nvim},#[fg=#{@c-green}]󰕷 ,$ICON_FORMAT}"
ICON_FORMAT="#{?#{==:#{pane_mode},copy-mode},#[fg=#{@c-green}]󰕷 ,$ICON_FORMAT}"

#---------------------- Windows 状态栏 ------------------------
# 非当前窗口
WS_FORMAT=""
WS_FORMAT+="#[fg=#{@c-black},bg=default]$RIGHT_ICON_INVERSE"
WS_FORMAT+="#[fg=#{@c-bwhite},bg=#{@c-black}] $ICON_FORMAT#[fg=#{@c-bwhite}]#W "
WS_FORMAT+="#[fg=#{@c-red}]#{?pane_in_mode, ,}"
WS_FORMAT+="#[fg=#{@c-yellow}]#{?window_bell_flag,󰂠 ,}"
WS_FORMAT+="#[fg=#{@c-yellow}]#{?window_activity_flag,󰂚 ,}"
WS_FORMAT+="#[fg=#{@c-ghgreen}]#{?window_zoomed_flag, ,}"
WS_FORMAT+="#[fg=#{@c-ghgreen}]#{?window_last_flag, ,}"
WS_FORMAT+="#[fg=#{@c-black},bg=default]$RIGHT_ICON"

# 当前窗口
WSC_FORMAT=""
WSC_FORMAT+="#[fg=#{@c-bblack},bg=default]$RIGHT_ICON_INVERSE"
WSC_FORMAT+="#[fg=#{@c-white},bg=#{@c-bblack}] $ICON_FORMAT#[fg=#{@c-white}]#W "
WSC_FORMAT+="#[fg=#{@c-red}]#{?pane_in_mode, ,}"
WSC_FORMAT+="#[fg=#{@c-ghgreen}]#{?window_zoomed_flag, ,}"
WSC_FORMAT+="#[fg=#{@c-ghgreen}] "
WSC_FORMAT+="#[fg=#{@c-bblack},bg=default]$RIGHT_ICON"

tmux_set window-status-format          "$WS_FORMAT"
tmux_set window-status-current-format  "$WSC_FORMAT"
tmux_set window-status-bell-style      "blink"
tmux_set window-status-activity-style  "blink"

#---------------------- 左状态栏 ------------------------------
tmux_set status-left-length 0
tmux_set status-left-style none

LS_ICON="#{?#{==:#{pane_current_command},ssh},#[fg=#{@c-red}]󰅡 ,󰤂 }"
LS_ICON="#{?client_prefix,#[fg=#{@c-yellow}]󰠠 ,$LS_ICON}"
LS_ICON="#{?synchronize-panes,#[fg=#{@c-green}]󱍸 ,$LS_ICON}"
LS_ICON="#{?pane_in_mode,#[fg=#{@c-red}]󰗦 ,$LS_ICON}"

STATUS_LEFT=""
STATUS_LEFT+="#[fg=#{@c-bblack},bg=#{@c-blue},bold,nodim]  "
STATUS_LEFT+="#[fg=#{@c-bblack},bg=#{@c-blue},bold,nodim]#S "
STATUS_LEFT+="#[fg=#{@c-blue},bg=default]$RIGHT_ICON"

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
tmux_set @download_speed  "#(~/.config/tmux/script/net-speed.sh rx_bytes '%%7s')"
tmux_set @cpu_usage       "#(~/.config/tmux/script/cpu-usage.sh)"
tmux_set @ssh_host        "#(~/.config/tmux/script/ssh-host.sh #{pane_pid})"
# tmux_set @claude_tokens   "#(~/.config/tmux/script/claude-token.sh)"
tmux_set @claude_tokens   "#(~/.config/tmux/script/claude-token.sh #{pane_current_path})"

GIT_BRANCH="#(git -C #{pane_current_path} rev-parse --abbrev-ref HEAD)"

#---------------------- 右侧各块（右→左） -----------------------
SEG_TIME="#[fg=#{@c-blue}]#[bg=default]$LEFT_SEP#[fg=#{@c-bg}]#[bg=#{@c-blue}]$TIME_ICON #[bg=default]#[fg=#{@c-white}] $TIME_FORMAT "
SEG_SPEED="#[fg=#{@c-cyan}]#[bg=default]$LEFT_SEP#[fg=#{@c-bg}]#[bg=#{@c-cyan}]$DOWNLOAD_ICON #[bg=default]#[fg=#{@c-white}]#{E:@download_speed}"
SEG_CPU="#[fg=#{@c-cyan}]#[bg=default]$LEFT_SEP#[fg=#{@c-bg}]#[bg=#{@c-cyan}]$CPU_ICON#[bg=default]#[fg=#{@c-white}] #{E:@cpu_usage}"
SEG_GIT="#[fg=#{@c-green}]#[bg=default]$LEFT_SEP#[fg=#{@c-bg}]#[bg=#{@c-green}] #[bg=default]#[fg=#{@c-white}] $GIT_BRANCH"
SEG_SSH="#[fg=#{@c-red}]#[bg=default]$LEFT_SEP#[fg=#{@c-bg}]#[bg=#{@c-red}]$SSH_ICON#[bg=default]#[fg=#{@c-white}] #{E:@ssh_host} "
SEG_CLAUDE="#[fg=#{@c-blue}]#[bg=default]$LEFT_SEP#[fg=#{@c-bg}]#[bg=#{@c-blue}]󰚩 #[bg=default]#[fg=#{@c-white}] #{E:@claude_tokens}"

# 状态标记块
SEG_SYNC="#[fg=#{@c-yellow}]#[bg=default]$LEFT_SEP#[fg=#{@c-bg}]#[bg=#{@c-yellow}]󰓦 #[bg=default]#[fg=#{@c-white}] SYNC"
SEG_VI="#[fg=#{@c-green}]#[bf=default]$LEFT_SEP#[fg=#{@c-bg}]#[bg=#{@c-green}] #[bg=default]#[fg=#{@c-white}] COPY"
SEG_PREFIX="#[fg=#{@c-yellow}]#[bg=default] 󰘳 "

# 右侧最终拼接（条件 + 信息块）
STATUS_RIGHT="$SEG_SPEED $SEG_CPU $SEG_TIME"
STATUS_RIGHT="#{?#{==:#{pane_current_command},ssh},$SEG_SSH,}$STATUS_RIGHT"
STATUS_RIGHT="#{?$GIT_BRANCH,$SEG_GIT ,}$STATUS_RIGHT"
STATUS_RIGHT="#{?#{==:#{pane_current_command},claude},$SEG_CLAUDE ,}$STATUS_RIGHT"
STATUS_RIGHT="#{?synchronize-panes,$SEG_SYNC ,}$STATUS_RIGHT"
STATUS_RIGHT="#{?pane_in_mode,$SEG_VI ,}$STATUS_RIGHT"
STATUS_RIGHT="#{?client_prefix,$SEG_PREFIX ,}$STATUS_RIGHT"

tmux_set status-right "$STATUS_RIGHT"
