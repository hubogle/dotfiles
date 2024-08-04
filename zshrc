export LC_ALL=zh_CN.UTF-8
export LANG=zh_CN.UTF-8
# zmodload zsh/zprof # zprof | head -n 20; zmodload -u zsh/zprof
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
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache
export EDITOR="$BREW_PATH/nvim"
export VISUAL="$BREW_PATH/nvim"
export SHELL_SESSIONS_DISABLE=1
export LESSHISTFILE=$XDG_DATA_HOME/less/history
export HISTFILE=$XDG_DATA_HOME/zsh_history   # zsh 历史文件地址
#=====================other config==============
export HOMEBREW_NO_AUTO_UPDATE=true     # brew 不自动更新
export IPYTHONDIR=$XDG_DATA_HOME/ipython
export MYCLI_HISTFILE=$XDG_DATA_HOME/mycli/history
export HISTDB_FILE=$XDG_DATA_HOME/histdb/zsh-history.db
#=====================P10k======================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
#======================ZI========================
source "${HOME}/.zi/bin/zi.zsh"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi

setopt prompt_subst             # 每次绘制提示时启用提示内的参数替换。

zi wait lucid for \
  OMZL::git.zsh \
  OMZP::git \
  OMZP::extract

zi ice depth'1' atload"[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" nocd
zi light romkatv/powerlevel10k

zi wait lucid light-mode for \
  Aloxaf/fzf-tab \
  z-shell/zsh-zoxide \
  z-shell/H-S-MW
  # larkery/zsh-histdb

# https://wiki.zshell.dev/zh-Hans/docs/guides/syntax/for
# z-shell/H-S-MW             # 搜索历史命令，可以查看上下文
# echo $FPATH 根据路径生效优先级生效，如 homebrew/share/zsh/site-functions/_git 删除
# compinit -d ~/.cache/zi/zcompdump-$ZSH_VERSION

zi wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
    z-shell/F-Sy-H \
  atload"_zsh_autosuggest_start; \
        ZSH_AUTOSUGGEST_STRATEGY=(history completion) \
        ZSH_AUTOSUGGEST_MANUAL_REBIND=0 \
        ZSH_AUTOSUGGEST_HISTORY_IGNORE=' *' \
        bindkey '^p' history-search-backward; \
        bindkey '^o' history-search-forward; \
        bindkey '^[[Z' autosuggest-accept; \
        bindkey '^e' autosuggest-execute; \
        bindkey '^a' autosuggest-toggle; \
        bindkey '^s' autosuggest-clear" \
    zsh-users/zsh-autosuggestions \
  blockf atpull'zi creinstall -q .' \
    zsh-users/zsh-completions

# bindkey '^[[Z' autosuggest-accept      # shift + tab  | 补全历史命令

source ~/.config/zsh/fzf-tab.zsh
source ~/.config/zsh/history.zsh
# source ~/.config/zsh/histdb.zsh
#=====================RCM===========================
export DOTFILES_DIRS=$HOME/Documents/File/dotfiles
export RCRC=$HOME/.config/rcm/rcrc
#=======================mise=====================
export MISE_DATA_DIR=$HOME/.mise
eval "$(mise activate zsh --shims)"
#=======================goEnv====================
export GO111MODULE=on # auto
export GOPROXY=https://goproxy.cn
export GOPATH=$(mise where go)/packages
export GOROOT=$(mise where go)
#========================fzf========================
source $BREW_OPT/fzf/shell/completion.zsh 2> /dev/null # 将 .fzf.zsh 内容抽离出来
# https://vitormv.github.io/fzf-themes/
# # https://github.com/junegunn/fzf/wiki/Color-schemes
export FZF_DEFAULT_OPTS="
  --height 40%
  --reverse
  --border none
  --ansi
  --color fg:242,bg:236,hl:65,fg+:15,bg+:239,hl+:108
  --color info:108,prompt:109,spinner:108,pointer:168,marker:168
  --preview 'bat --style=numbers --color=always --line-range :500 {}'
"
#=====================zoxide=======================
export _ZO_DATA_DIR=$HOME/.cache/zoxide              # 可删除 zcompdump
export _ZO_FZF_OPTS=$FZF_DEFAULT_OPTS
eval "$(zoxide init zsh --cmd cd)"                   # 在调用 compinit 后添加上述行
#===================NAVI============================
eval "$(navi widget zsh)"
export NAVI_CONFIG=$HOME/.config/navi/config.yaml
#===================BindKey=========================
bindkey '^f' vi-forward-word # 右移一个单词 [option]+[→] 和 [option]+[←]
bindkey '^b' vi-backward-word
#===================LSCOLOR=========================
# 彩色补全菜单
# https://github.com/trapd00r/LS_COLORS  LS_COLORS环境变量
export CLICOLOR=1
export LS_COLORS="$(vivid generate one-dark)"                 # vivid themes 预览
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}         # 颜色补全
#===================ALIAS===========================
alias ls='eza'
alias cat='bat'
alias r='trash'
alias rm='trash'
alias c='clear'
alias ping='ping -c 5'
alias cp="cp -i"    # 防止拷贝覆盖
alias l='eza --long --all --git --icons --time-style long-iso --colour-scale --header --group'
alias ll='eza --long --all --git --icons  --time-style iso --colour-scale --no-user --no-permissions --sort modified'
alias tree='eza --tree' # -L , --level=(depth)  递归的深度
alias vi='nvim'
alias vim='nvim'
alias top='btm'
alias q='exit'
alias lip="curl cip.cc; curl ifconfig.me"
alias brewc="brew update && brew upgrade --formula && brew cleanup --prune 1 && brew autoremove" # mas upgrade
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

ssh() {
    local original_term=$TERM
    TERM='xterm-256color'  # Set TERM for SSH sessions

    if [[ $(ps -p $(ps -p $$ -o ppid=) -o comm=) =~ tmux ]]; then
        local ssh_command="$@"
        local target_host=$(echo "$ssh_command" | awk -F'@' '{if (NF>1) print $2; else print $1}' | awk '{print $1}')
        tmux rename-window "$target_host"
        command ssh "$@"
        tmux rename-window "zsh"  # Reset window name after SSH
        [ $? -ne 0 ] && printf '\e[?1000l'
    else
        command ssh "$@"
    fi

    TERM=$original_term  # Restore original TERM after SSH
}

# 使用 vim 编辑当前输入的命令
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line                  # control + x + control + e
bindkey "^[m" copy-prev-shell-word                    # option + m 快速复制前面的单词
bindkey '\ew' kill-region                             # [Esc-w] - Kill from the cursor to the mark  C-x C-y
bindkey -s '\el' 'ls\n'                               # [Esc-l] - run command: ls

# vsocde shell integration
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"
export VSCODE_SUGGEST=1
export ITERM_SHELL_INTEGRATION_INSTALLED=Yes


_aichat_zsh() {
    if [[ -n "$BUFFER" ]]; then
        local _old=$BUFFER
        BUFFER+="⌛"
        zle -I && zle redisplay
        BUFFER=$(aichat -e "$_old")
        zle end-of-line
    fi
}
zle -N _aichat_zsh
bindkey '\ei' _aichat_zsh # [Esc-i]

export AICHAT_CONFIG_DIR="~/.config/aichat"
export AICHAT_ROLES_FILE="~/.config/aichat/roles.yaml"
alias ais="aichat -r shell -e"

# https://gist.github.com/bbqtd/a4ac060d6f6b9ea6fe3aabe735aa9d95
update_terminfo () {
    local x ncdir terms
    ncdir="/opt/homebrew/opt/ncurses"
    terms=(alacritty-direct alacritty tmux tmux-256color)

    mkdir -p ~/.terminfo && cd ~/.terminfo

    if [ -d $ncdir ] ; then
        # sed : fix color for htop
        for x in $terms ; do
            $ncdir/bin/infocmp -x -A $ncdir/share/terminfo $x > ${x}.src &&
            sed -i '' 's|pairs#0x10000|pairs#32767|' ${x}.src &&
            /usr/bin/tic -x ${x}.src &&
            rm -f ${x}.src
        done
    fi
    cd - > /dev/null
}
