#=====================P10k======================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#================================================
#======================忽略大小写==================
autoload -Uz compinit && compinit -u
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
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
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup  # 使用 tmux 弹出窗口
# zstyle ':fzf-tab:*' fzf-command fzf

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
export HISTCONTROL=ignoreboth # 忽略重复的命令
# ignorespace: 忽略空格开头的命令
# ignoredups: 忽略连续重复命令
# ignoreboth: 表示上述两个参数都设置
export HISTSIZE=10000
export SAVEHIST=10000
setopt SHARE_HISTORY            # 在所有会话之间共享历史记录
setopt INC_APPEND_HISTORY       # 立即写入历史文件，不要在shell退出时写入。
setopt HIST_IGNORE_ALL_DUPS     # 如果新记录是重复的，则删除旧记录
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
#========================fzfp========================
#https://github.com/kevinhwang91/fzf-tmux-script/tree/main/popup
# https://github.com/kevinhwang91/fzf-tmux-script/blob/main/popup/fzfp
if [[ -n $TMUX_PANE ]] && (( $+commands[tmux] )) && (( $+commands[fzfp] )); then
    export TMUX_POPUP_NESTED_FB='test $(tmux display -pF "#{==:#S,floating}") == 1'
    export TMUX_POPUP_WIDTH=80%
fi
[[ $- == *i* ]] && source "/opt/homebrew/opt/fzf/shell/completion.zsh" 2> /dev/null   # 将 .fzf.zsh 内容抽离出来
export FZF_DEFAULT_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"
#====================================================
#===================NAVI============================
eval "$(navi widget zsh)"
export NAVI_CONFIG=$HOME/.config/navi/config.yaml
#===================================================
#=====================RCM===========================
export RCRC=$HOME/.config/rcm/rcrc
export DOTFILES_DIRS="/Users/hubo/Documents/File/dotfiles"
export EXCLUDES="readme.md Brewfile aria2"
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
#===================================================