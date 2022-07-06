export LC_ALL=zh_CN.UTF-8
export LANG=zh_CN.UTF-8
#====================PATH=======================
if [[ `arch` == "arm64" ]]; then
  export BREW_OPT="/opt/homebrew/opt"
  export BREW_PATH="/opt/homebrew/bin"
  export BREW_SBIN="/opt/homebrew/sbin"
else
  export BREW_OPT="/usr/local/opt"
  export BREW_PATH="/usr/local/bin"
  export BREW_SBIN="/usr/local/sbin"
fi
export PATH="$BREW_PATH:$BREW_SBIN:$PATH"
#=====================config====================
export LESSHISTFILE=~/.local/share/less/history
export MYCLI_HISTFILE=~/.local/share/mycli/history
export IPYTHONDIR=~/.local/share/ipython
export SHELL_SESSIONS_DISABLE=1
export EDITOR="nvim"
#===============================================
#=====================按键=======================
# option + f 光标右移一个单词
# option + b 光标左移一个单词
# option + d 删除光标右侧所有
# control + w 删除左边一个单词
# control + f 光标右移一个单词
# control + b 光标左移一个单词
#===============================================
#=====================P10k======================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#================================================
#======================brew=======================
alias brewc="brew update && brew upgrade --formula && mas upgrade && brew cleanup --prune 1 && brew autoremove"
export FPATH=$(brew --prefix)/opt/zsh/share/zsh/functions:$FPATH # 调整zsh函数优先提示路径
export HOMEBREW_NO_AUTO_UPDATE=true     # 自动更新关闭
#=================================================
#======================ZI========================
#https://z-shell.pages.dev/zh-Hans/docs/getting_started/installation/
source "${HOME}/.zi/bin/zi.zsh"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi

# 初始化自动完成
autoload -Uz compinit

# zcompdump 存储路径配置
compinit -d ~/.cache/zi/zcompdump-$ZSH_VERSION

zi ice wait lucid has'fzf'
zi light Aloxaf/fzf-tab               # fzf 提供补全菜单

# zi light z-shell/H-S-MW             # 搜索历史命令，可以查看上下文
zi ice wait lucid
zi light larkery/zsh-histdb           # histdb 记录历史 ~/.histdb

# rm -f ~/.zcompdump; compinit
zi ice lucid wait as'completion'
zi light zsh-users/zsh-completions    # 自动补全

zi ice depth=1
zi light romkatv/powerlevel10k        # p10k 主题

zi ice wait lucid atload"!_zsh_autosuggest_start"
zi light zsh-users/zsh-autosuggestions # 提示根据历史记录和补全提示您输入的命令
bindkey '^[[Z' autosuggest-accept      # shift + tab  | 补全历史命令

zi ice wait lucid atinit"ZI[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay"
zi light z-shell/F-Sy-H # 高亮插件

zi snippet OMZP::extract               # x 一键解压
zi snippet OMZL::git.zsh               # git alias
zi snippet OMZP::git                   # git alias
#==================================================
#====================历史记录========================
# https://z-shell.pages.dev/zh-Hans/docs/guides/customization
export HISTTIMEFORMAT="%F %T "
export SAVEHIST=100000          # 默认保存 10000 $HISTSIZE
export HISTSIZE=100000
setopt HIST_IGNORE_ALL_DUPS     # 从历史记录中删除较旧的重复条目
setopt HIST_IGNORE_DUPS         # 如果连续输入的命令相同，历史纪录中只保留一个
setopt HIST_REDUCE_BLANKS       # 在记录条目之前删除多余的空格
setopt HIST_IGNORE_SPACE        # 不要记录以空格开头的条目
setopt HIST_SAVE_NO_DUPS        # 不要在历史记录文件中写入重复条目
setopt APPEND_HISTORY           # 允许多个终端会话都附加到一个 zsh 命令历史记录
setopt EXTENDED_HISTORY         # 为历史纪录中的命令添加时间戳
setopt INC_APPEND_HISTORY       # 立即写入历史文件，不要在shell退出时写入
setopt SHARE_HISTORY            # 在所有会话之间共享历史记录
# setopt HIST_VERIFY              # 不要在历史扩展后立即执行
# setopt HIST_BEEP                # 访问不存在的历史记录时发出哔哔声
#===================其它===============================
setopt INTERACTIVE_COMMENTS     # 允许在交互模式中使用注释  例如：cmd #这是注释
setopt PUSHD_IGNORE_DUPS        # 不要将同一目录的多个副本推送到目录堆栈上
setopt auto_cd                  # 如果不是命令，则通过键入目录名称来使用 cd。
setopt no_beep                  # 不要在错误时发出哔哔声
setopt auto_list                # 自动列出模棱两可的完成选项。
setopt auto_pushd               # 使 cd 将旧目录推送到目录堆栈上。
setopt pushdminus               # 交换了 cd +1 和 cd -1 的含义；我们希望他们的意思与他们的意思相反。
setopt promptsubst              # 每次绘制提示时启用提示内的参数替换。
# setopt GLOB_COMPLETE          # Show autocompletion menu with globs
setopt MENU_COMPLETE            # 自动突出显示完成菜单的第一个元素
setopt AUTO_LIST                # 自动列出不明确完成的选项
setopt COMPLETE_IN_WORD         # 从一个词的两端完成的
# setopt glob_dots                # cd 提示所有隐藏文件
#======================================================
#========================fzf-tab=======================
# fzf-tab 预览调整 https://github.com/Aloxaf/fzf-tab/wiki/Preview
# 分组调色 https://github.com/Aloxaf/fzf-tab/wiki/Configuration#group-colors
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:*' switch-group ',' '.'        # 来回切换分组展示
zstyle ':fzf-tab:*' prefix ''                   # 取消展示的 .
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup  # 使用 tmux 弹出窗口
zstyle ':fzf-tab:complete:cd:*' popup-pad 30 10
# zstyle ':fzf-tab:*' fzf-command fzf
zstyle ':fzf-tab:*' fzf-flags '--color=hl:red'   # 输入中匹配字符的颜色
zstyle ':fzf-tab:*' default-color $'\033[38;5;115m'   # 没有组显示颜色
zstyle ':fzf-tab:*' single-group color          # 一组时显示颜色，默认配色
zstyle ':fzf-tab:*' show-group full             # 分组描述显示配置
FZF_TAB_GROUP_COLORS=(
    $'\033[94m' $'\033[32m' $'\033[33m' $'\033[35m' $'\033[31m' $'\033[38;5;27m' $'\033[36m' \
    $'\033[38;5;100m' $'\033[38;5;98m' $'\033[91m' $'\033[38;5;80m' $'\033[92m' \
    $'\033[38;5;214m' $'\033[38;5;165m' $'\033[38;5;124m' $'\033[38;5;120m'
)
zstyle ':fzf-tab:*' group-colors $FZF_TAB_GROUP_COLORS  # 分组时配色
#======================================================
#========================zstyle=======================o=
# 参考 https://github.com/sorin-ionescu/prezto/blob/master/modules/completion/init.zsh
zstyle ':completion:*' use-cache true                         # 对使用缓存的命令使用缓存
# zcompcache 存储路径配置
zstyle ':completion:*' cache-path "$HOME/.cache/zi/zcompcache"
zstyle ':completion:*' menu select                            # 允许您在菜单中选择
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'  # 大小写模糊
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*'        # 虚线值的智能匹配，例如f-b匹配foo-bar
zstyle ':completion:*' complete-options true                  # 自动完成cd而不是目录堆栈的选项
zstyle ':completion:*' rehash true                            # 自动更新PATH条目
zstyle ':completion:*' verbose yes                            # 详细的完成结果

# 彩色补全菜单
# https://github.com/trapd00r/LS_COLORS  LS_COLORS环境变量
export LS_COLORS="$(vivid generate one-dark)"                 # vivid themes 预览
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}         # 颜色补全

#模糊匹配，错误校正
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*'  # 虚线值的智能匹配，例如f-b匹配foo-bar

#路径补全
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'     # //扩展为/.
zstyle ':completion::complete:*' '\\'
zstyle ':completion:*' accept-exact-dirs true    # 如果目录存在，不要尝试父路径补全

# 提示文件排序类型
zstyle ':completion:*' sort false             # 关闭默认排序
zstyle ':completion:*' file-sort modification # 修改日期对完成列表进行排序

#补全类型提示分组
zstyle ':completion:*' group-name ''          # 按类别将结果分组
zstyle ':completion:*' list-dirs-first true   # 将目录和文件分开
zstyle ':completion:*' format '[%d]'          # 添加这个才会分组
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
# zstyle ':completion:*:*:(vi|vim):*' ignored-patterns '*.(o|d)'  # 智能提示时忽略 o d 结尾文件

# 分页期间的漂亮消息
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

# scp file username@<TAB><TAB>:/<TAB>
zstyle ':completion:*:(ssh|scp|ftp|sftp):*' hosts $hosts
# zstyle ':completion:*:(ssh|scp|ftp|sftp):*' users $users
zstyle ':completion:*:(ssh|scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost ip6-allnodes ip6-allrouters
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*' 'ff02::1' 'ff02::2' '127.0.1.<->'

# 这里必须要忽略不必要的名称
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:*:*:*:users' ignored-patterns \
  adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
  dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
  hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
  mailman mailnull mldonkey mysql nagios \
  named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
  operator pcap postfix postgres privoxy pulse pvm quagga radvd \
  rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs '_*'
#====================================================
#=====================H-S-MW========================
# zstyle ":history-search-multi-word" page-size "8"                      # Number of entries to show (default is $LINES/3)
zstyle ":history-search-multi-word" highlight-color "fg=yellow,bold"   # Color in which to highlight matched, searched text (default bg=17 on 256-color terminals)
zstyle ":plugin:history-search-multi-word" synhl "yes"                 # Whether to perform syntax highlighting (default true)
zstyle ":plugin:history-search-multi-word" active "underline"          # Effect on active history entry. Try: standout, bold, bg=blue (default underline)
zstyle ":plugin:history-search-multi-word" check-paths "yes"           # Whether to check paths for existence and mark with magenta (default true)
zstyle ":plugin:history-search-multi-word" clear-on-cancel "no"        # Whether pressing Ctrl-C or ESC should clear entered query
#===================================================
#======================proxy=====================
function proxy() {
    export no_proxy="localhost,127.0.0.1"
    export http_proxy=http://127.0.0.1:7890
    export https_proxy=http://127.0.0.1:7890
    export all_proxy=socks5://127.0.0.1:7891
}
function unproxy(){
    unset http_proxy
    unset https_proxy
    unset all_proxy
    echo -e "关闭代理"
}
#proxy
#=======================asdf=====================
export ASDF_CONFIG_FILE=$HOME/.config/asdfrc
source $BREW_OPT/asdf/libexec/asdf.sh
#================================================
#=======================goEnv====================
export GO111MODULE=on # auto
export GOPROXY=https://goproxy.cn
#===================================================
#========================fzf========================
source $BREW_OPT/fzf/shell/completion.zsh 2> /dev/null # 将 .fzf.zsh 内容抽离出来
# export FZF_DEFAULT_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"
export FZF_DEFAULT_OPTS="
  --height 40%
  --reverse
  --border
  --ansi
  --bind='ctrl-r:toggle-sort'
  --bind='ctrl-d:execute(source ~/.zi/plugins/larkery---zsh-histdb/sqlite-history.zsh && yes | histdb --forget --exact --yes {} > /dev/null 2>&1)'
"
#===================================================
#=====================zoxide=======================
# 更智能的CD命令，可跳转目录
export _ZO_DATA_DIR=$HOME/.cache/zoxide              # 可删除 zcompdump
eval "$(zoxide init zsh --cmd cd)"                   # 在调用compinit后添加上述行
#==================================================
#===================NAVI============================
eval "$(navi widget zsh)"
export NAVI_CONFIG=$HOME/.config/navi/config.yaml
#===================================================
#=====================RCM===========================
export DOTFILES_DIRS=$HOME/Documents/File/dotfiles
export RCRC=$HOME/.config/rcm/rcrc
#===================================================
#===================histdb==========================
export HISTDB_FILE=$HOME/.local/share/histdb/zsh-history.db
export HISTFILE=$HOME/.local/share/zsh_history   # zsh 历史文件地址
HISTDB_TABULATE_CMD=(sed -e $'s/\x1f/\t/g')
autoload -Uz add-zsh-hook
if [[ -f "$HISTDB_FILE" ]]; then
  _zsh_autosuggest_strategy_histdb_top() {
      local query="
          select commands.argv from history
          left join commands on history.command_id = commands.rowid
          left join places on history.place_id = places.rowid
          where commands.argv LIKE '$(sql_escape $1)%'
          group by commands.argv, places.dir
          order by places.dir != '$(sql_escape $PWD)', count(*) desc
          limit 1
      "
      suggestion=$(_histdb_query "$query")
  } # 查找在当前目录或任何子目录中发出的最常发出的命令
  ZSH_AUTOSUGGEST_STRATEGY=histdb_top
fi
histdb-fzf-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
  selected=( $(histdb --sep 999 | awk -F'999' '{ if (!seen[$4]++) {print $4} }' |
    FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m --tac" fzf) )
  LBUFFER=$selected
  zle redisplay
  typeset -f zle-line-init >/dev/null && zle zle-line-init
  return $ret
}
zle     -N   histdb-fzf-widget
bindkey '^R' histdb-fzf-widget
#===================================================
#===================BindKey=========================
bindkey '^f' vi-forward-word # 右移一个单词 [option]+[→] 和 [option]+[←]
bindkey '^b' vi-backward-word
#===================================================
#===================ALIAS===========================
alias ls='exa'
alias cat='bat'
alias r='trash'
alias rm='trash'
alias c='clear'
alias ping='ping -c 5'
alias cp="cp -i"    # 防止拷贝覆盖
alias l='exa --long --all --git --icons --time-style long-iso --colour-scale --header --group'
alias ll='exa --long --all --git --icons  --time-style iso --colour-scale --no-user --no-permissions --sort modified'
alias tree='exa --tree' # -L , --level=(depth)  递归的深度
alias vi='nvim'
alias vim='nvim'
alias top='btm'
alias q='exit'
alias lip="curl cip.cc; curl ifconfig.me"
#===================================================
