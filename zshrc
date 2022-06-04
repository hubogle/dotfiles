# Ignore lower upper
autoload -Uz compinit && compinit -u
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

source /opt/homebrew/opt/zinit/zinit.zsh
#=======================p10k======================
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# p10k configure
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
#=================================================
#======================brew=======================
#alias brewc="brew update && brew upgrade && brew upgrade --cask --greedy && brew cleanup --prune 1 && brew doctor"
#alias brewc="brew update && brew upgrade && brew cleanup --prune 1 && brew doctor"
alias brewc="brew update && brew upgrade --formula && brew cleanup --prune 1 && brew autoremove"
export HOMEBREW_NO_AUTO_UPDATE=true     # 自动更新关闭
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
#================================================
#======================fzf=======================
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
### fzf 界面展示
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --preview '(highlight -O ansi {} || cat {} || tree -C {}) 2> /dev/null | head -500'"
#================================================
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
#====================PyEnv======================
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
#===============================================
#====================GoEnv======================
export GOENV_ROOT="$HOME/.goenv"
export GOENV_GOPATH_PREFIX="$GOENV_ROOT/go"
export GOPATH="$GOENV_GOPATH_PREFIX/1.18.0"
export PATH="$GOPATH/bin:$GOENV_ROOT/shims:$PATH"
#export GO111MODULE=on
export GO111MODULE=auto
export GOPROXY=https://goproxy.cn
#===============================================
#==================npm=========================
#https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally
NPM_CONFIG_PREFIX=~/.npm-global
#==============================================
# z.lua
#zinit ice lucid wait='1'
#zinit light skywind3000/z.lua

# p10k界面
#zinit ice depth=1
#zinit light romkatv/powerlevel10k

# fzf提供补全菜单
zinit light Aloxaf/fzf-tab
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
#zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:complete:*:*' extra-opts --preview=$extract";$PREVIEW \$in"
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

# 高亮
zinit ice lucid wait='0' atinit='zpcompinit'
zinit light zdharma-continuum/fast-syntax-highlighting
# 提示
zinit ice lucid wait='0' atload='_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions
# 自动补全
zinit ice lucid wait='0'
zinit light zsh-users/zsh-completions
# git 插件
zinit ice lucid wait='0'
zinit light wfxr/forgit
# 快速跳转目录
#zinit ice wait"2" as"null" from"gh-r" lucid \
#    mv"**/man/zoxide.1 -> $ZPFX/share/man/man1/" sbin"**/zoxide" \
#    atclone"zoxide init zsh > init.zsh" \
#    atpull"%atclone" src"init.zsh" nocompile'!'
zinit ice lucid wait='0'
zinit light ajeetdsouza/zoxide

#=======================OMZ====================
zinit snippet OMZ::lib/git.zsh
zinit snippet OMZ::plugins/git/git.plugin.zsh

#======================zoxide==================
eval "$(zoxide init zsh)"
export _ZO_DATA_DIR='/Users/hubo/.cache/zoxide'
#==============================================

alias ls='exa'
alias cat='bat'
alias r='trash'
alias mvi='mvim'
alias rm='trash'
alias c='clear'
alias ping='ping -c 5'
alias cp="cp -i"    # 防止拷贝覆盖
alias s3test="s3cmd -c ~/.s3cmd/test -H"
alias s3uat="s3cmd -c ~/.s3cmd/uat -H"
alias s3prod="s3cmd -c ~/.s3cmd/prod -H"
alias s3dar="s3cmd -c ~/.s3cmd/dar-prod -H"
alias ll='exa --long --all --header --icons --git --time-style long-iso'
alias vi='nvim'

# To customize prompt, run `p10k configure` or edit ~/.dotfiles/zsh/.p10k.zsh.
[[ ! -f ~/.dotfiles/zsh/.p10k.zsh ]] || source ~/.dotfiles/zsh/.p10k.zsh

#export HISTTIMEFORMAT='%F %T '
#export HISTCONTROL=ignoredups # 忽略重复的命令
export HISTSIZE=10000
export SAVEHIST=10000

# https://qastack.cn/unix/273861/unlimited-history-in-zsh
setopt SHARE_HISTORY  			# 在所有会话之间共享历史记录
setopt INC_APPEND_HISTORY 		# 立即写入历史文件，不要在shell退出时写入。
setopt HIST_IGNORE_ALL_DUPS     # 如果新记录是重复的，则删除旧记录


