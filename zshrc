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
export LESSHISTFILE=$HOME/.local/share/less/history
export MYCLI_HISTFILE=$HOME/.local/share/mycli/history
export IPYTHONDIR=$HOME/.local/share/ipython
export HISTDB_FILE=$HOME/.local/share/histdb/zsh-history.db
export HISTFILE=$HOME/.local/share/zsh_history   # zsh 历史文件地址
export SHELL_SESSIONS_DISABLE=1
export EDITOR="nvim"
export HOMEBREW_NO_AUTO_UPDATE=true     # brew 不自动更新
#=====================P10k======================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#======================ZI========================
source "${HOME}/.zi/bin/zi.zsh"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi

autoload -Uz compinit                 # 初始化自动完成

# zcompdump 存储路径配置，如果失效的话则只执行 compinit
# echo $FPATH 根据路径生效优先级生效，如 homebrew/share/zsh/site-functions/_git 删除
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
zi light z-shell/F-Sy-H                # 高亮插件

zi ice has'zoxide'
zi light z-shell/zsh-zoxide

# https://wiki.zshell.dev/docs/getting_started/migration
zi snippet OMZP::extract               # x 一键解压
zi snippet OMZL::git.zsh               # git alias
zi snippet OMZP::git                   # git alias
zi snippet OMZP::golang                # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/golang
zi snippet OMZP::gitignore             # https://www.toptal.com/developers/gitignore
zi snippet OMZP::cp                    # cpv 使用 rsync 带进度条

source ~/.config/zsh/fzf-tab.zsh
source ~/.config/zsh/history.zsh
source ~/.config/zsh/histdb.zsh
#=====================RCM===========================
export DOTFILES_DIRS=$HOME/Documents/File/dotfiles
export RCRC=$HOME/.config/rcm/rcrc
#=======================asdf=====================
export ASDF_CONFIG_FILE=$HOME/.config/asdfrc
source $BREW_OPT/asdf/libexec/asdf.sh
#=======================goEnv====================
export GO111MODULE=on # auto
export GOPROXY=https://goproxy.cn
#export GOPATH=$(asdf where golang)/packages
#export GOROOT=$(asdf where golang)/go
alias go-reshim='asdf reshim golang && export GOROOT="$(asdf where golang)/go/"'
#========================fzf========================
source $BREW_OPT/fzf/shell/completion.zsh 2> /dev/null # 将 .fzf.zsh 内容抽离出来
# export FZF_DEFAULT_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"
# https://github.com/junegunn/fzf/wiki/Color-schemes
export FZF_DEFAULT_OPTS="
  --height 40%
  --reverse
  --border none
  --ansi
  --color=gutter:#1E1E1E,bg+:#1E1E1E,fg:#42b3c2,fg+:#8cc265,hl+:#8cc265
  --bind='ctrl-r:toggle-sort'
"
  # --color=gutter:#282c34,bg+:#3e4452,hl:#8cc265,border:#3e4452,fg:#42b3c2 # one_dark_pro_flat 配色
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
alias brewc="brew update && brew upgrade --formula && mas upgrade && brew cleanup --prune 1 && brew autoremove"
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
    if (ps -p $(ps -p $$ -o ppid=) -o comm=) | grep -qw tmux; then
        tmux rename-window "$(echo $* | rev | cut -d ' ' -f1 | rev | cut -d . -f 1)"
        command ssh "$@"
        tmux set-window-option automatic-rename "on" 1>/dev/null
    else
        command ssh "$@"
    fi
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
