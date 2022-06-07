export LC_ALL=zh_CN.UTF-8
export LANG=zh_CN.UTF-8
#=====================P10k======================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#================================================
#======================brew=======================
alias brewc="brew update && brew upgrade --formula && mas upgrade && brew cleanup --prune 1 && brew autoremove"
export HOMEBREW_NO_AUTO_UPDATE=true     # 自动更新关闭
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
#=================================================
#======================ZI=========================
#https://z-shell.pages.dev/zh-Hans/docs/getting_started/installation/
zi_home="${HOME}/.zi"
source "${zi_home}/bin/zi.zsh"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi

zi light Aloxaf/fzf-tab     # fzf 提供补全菜单
zi light z-shell/H-S-MW  # 搜索历史命令，可以查看上下文

# rm -f ~/.zcompdump; compinit
zi light zsh-users/zsh-completions  # 自动补全

zi ice depth=1
zi light romkatv/powerlevel10k  # p10k 主题

zi ice wait lucid atload'_zsh_autosuggest_start'
zi light zsh-users/zsh-autosuggestions # 提示根据历史记录和补全提示您输入的命令
bindkey ',' autosuggest-accept # , 补全

zi ice wait lucid atinit='zpcompinit'
zi light zdharma/fast-syntax-highlighting # 高亮插件

zi snippet OMZL::git.zsh  # git alias
zi snippet OMZP::git  # git alias
#==================================================
#=====================zoxide=======================
# 更智能的CD命令，可跳转目录
eval "$(zoxide init zsh --cmd cd)"       # 在调用compinit后添加上述行
export _ZO_DATA_DIR='/Users/hubo/.cache/zoxide' # 可删除 zcompdump
#==================================================
#====================历史记录========================
# https://qastack.cn/unix/273861/unlimited-history-in-zsh
#export HISTCONTROL=ignoreboth # 忽略重复的命令
# ignorespace: 忽略空格开头的命令
# ignoredups: 忽略连续重复命令
# ignoreboth: 表示上述两个参数都设置
export HISTTIMEFORMAT="%F %T "
HISTFILE="$HOME/.zsh_history"   # zsh 历史文件地址
export SAVEHIST=100000          # 默认保存 10000 $HISTSIZE
export HISTSIZE=100000
setopt EXTENDED_HISTORY         # 为历史纪录中的命令添加时间戳
setopt INTERACTIVE_COMMENTS     # 允许在交互模式中使用注释  例如：cmd #这是注释
setopt PUSHD_IGNORE_DUPS        # 相同的历史路径只保留一个
setopt SHARE_HISTORY            # 在所有会话之间共享历史记录
setopt INC_APPEND_HISTORY       # 立即写入历史文件，不要在shell退出时写入
setopt HIST_IGNORE_ALL_DUPS     # 如果新记录是重复的，则删除旧记录
setopt HIST_IGNORE_SPACE        # 不要记录以空格开头的条目
setopt HIST_SAVE_NO_DUPS        # 不要在历史记录文件中写入重复条目
setopt HIST_REDUCE_BLANKS       # 在记录条目之前删除多余的空格
setopt HIST_IGNORE_DUPS         # 如果连续输入的命令相同，历史纪录中只保留一个
#setopt HIST_VERIFY              # 不要在历史扩展后立即执行
#setopt HIST_BEEP                # 访问不存在的历史记录时发出哔哔声
#======================================================
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
#===============================================
#=======================pyEnv====================
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
#================================================
#=======================goEnv====================
export GOENV_ROOT="$HOME/.goenv"
export GOENV_GOPATH_PREFIX="$GOENV_ROOT/go"
export GOPATH="$GOENV_GOPATH_PREFIX/1.18.0" # 自定义版本路径
export PATH="$GOPATH/bin:$GOENV_ROOT/shims:$PATH"
export GO111MODULE=auto # on
export GOPROXY=https://goproxy.cn
#===================================================
#========================fzf========================
source "/opt/homebrew/opt/fzf/shell/completion.zsh" 2> /dev/null # 将 .fzf.zsh 内容抽离出来
# export FZF_DEFAULT_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"
#===================================================
#========================fzf-tab====================
# # zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'  # 修正大小写
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}+l:|?=** r:|?=**'    # 允许自动完成不区分大小写
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}   # 突出显示当前的自动完成选项

# fzf-tab 预览调整 https://github.com/Aloxaf/fzf-tab/wiki/Preview
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup  # 使用 tmux 弹出窗口
zstyle ':fzf-tab:complete:cd:*' popup-pad 30 10
# zstyle ':fzf-tab:*' fzf-command fzf


# Better SSH/Rsync/SCP 完成功能
# zstyle ':completion:*:(scp|rsync):*' tag-order ' hosts:-ipaddr:ip\ address hosts:-host:host files'
# zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
# zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

#错误校正
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
#路径补全
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-shlashes 'yes'
zstyle ':completion::complete:*' '\\'

# 初始化自动完成
autoload -Uz compinit && compinit -u
#====================================================
#===================NAVI============================
eval "$(navi widget zsh)"
export NAVI_CONFIG=$HOME/.config/navi/config.yaml
#===================================================
#=====================RCM===========================
export DOTFILES_DIRS=$HOME/Documents/File/dotfiles
export RCRC=$HOME/.config/rcm/rcrc
#===================================================
#===================ALIAS===========================
alias ls='exa'
alias cat='bat'
alias r='trash'
alias rm='trash'
alias c='clear'
alias ping='ping -c 5'
alias cp="cp -i"    # 防止拷贝覆盖
alias ll='exa --long --all --header --icons --git --time-style long-iso'
alias vi='nvim'
alias vim='nvim'
alias mycli='mycli --myclirc ~/.config/mycli/myclirc'
alias top='btm'
alias q='exit'
alias lip="curl cip.cc; curl ifconfig.me"
hash -d dow="~/Downloads" # 路径别名
#===================================================
#====================sudo===========================
##在命令前插入 sudo
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    [[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER"
    zle end-of-line                 #光标移动到行末
}
zle -N sudo-command-line
#定义快捷键为： [Esc] [Esc]
bindkey "\e\e" sudo-command-line
#===================================================
# h=()
# if [[ -r ~/.ssh/config ]]; then
#   h=($h ${${${(@M)${(f)"$(cat ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*})
# fi
# if [[ -r ~/.ssh/known_hosts ]]; then
#   h=($h ${${${(f)"$(cat ~/.ssh/known_hosts{,2} || true)"}%%\ *}%%,*}) 2>/dev/null
# fi
# if [[ $#h -gt 0 ]]; then
#   zstyle ':completion:*:ssh:*' hosts $h
#   zstyle ':completion:*:slogin:*' hosts $h
# fi
