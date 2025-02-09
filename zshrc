export LANG="${LC_ALL:-en_US.UTF-8}"
unset LC_ALL
# zmodload zsh/zprof # zprof | head -n 20; zmodload -u zsh/zprof
#====================PATH=======================
export BREW_OPT="/opt/homebrew/opt"
export BREW_PATH="/opt/homebrew/bin"
export BREW_SBIN="/opt/homebrew/sbin"
export PATH="$BREW_PATH:$PATH"
#=====================config====================
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export EDITOR="$BREW_PATH/nvim"
export VISUAL="$BREW_PATH/nvim"
export SHELL_SESSIONS_DISABLE=1
export LESSHISTFILE=$XDG_STATE_HOME/less/history
export HISTFILE=$XDG_STATE_HOME/zsh/history
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export TERMINFO=$XDG_DATA_HOME/terminfo
#=====================other config==============
export HOMEBREW_NO_AUTO_UPDATE=true     # brew 不自动更新
export IPYTHONDIR=$XDG_STATE_HOME/ipython
export MYCLI_HISTFILE=$XDG_STATE_HOME/mycli/history
#======================ZI========================
source "${HOME}/.zi/bin/zi.zsh"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi

setopt prompt_subst             # 每次绘制提示时启用提示内的参数替换。

zi wait lucid for \
  OMZL::git.zsh \
  OMZP::git \
  OMZP::extract

zi light-mode for sindresorhus/pure

zi wait lucid light-mode for \
  atload'eval "$(atuin init zsh --disable-up-arrow)"' \
  Aloxaf/fzf-tab \
  has'eza' atinit'AUTOCD=1' \
  z-shell/zsh-eza \
  has'zoxide' atinit='_ZO_CMD_PREFIX=cd' \
  z-shell/zsh-zoxide \
  atinit'YSU_MESSAGE_POSITION="after"' \
  MichaelAquilina/zsh-you-should-use

# https://wiki.zshell.dev/zh-Hans/docs/guides/syntax/for
# echo $FPATH 根据路径生效优先级生效，如 homebrew/share/zsh/site-functions/_git 删除
# compinit -d ~/.cache/zi/zcompdump-$ZSH_VERSION

zi wait lucid light-mode for \
  atinit"ZI[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    z-shell/F-Sy-H \
  atload"!_zsh_autosuggest_start; \
        ZSH_AUTOSUGGEST_STRATEGY=(history completion) \
        ZSH_AUTOSUGGEST_MANUAL_REBIND=0 \
        ZSH_AUTOSUGGEST_HISTORY_IGNORE=' *' \
        bindkey '^p' history-search-backward; \
        bindkey '^o' history-search-forward; \
        bindkey '^[[Z' autosuggest-accept; \
        bindkey '^s' autosuggest-clear" \
    zsh-users/zsh-autosuggestions \
  blockf atpull'zi creinstall -q .' \
    zsh-users/zsh-completions

autoload -U edit-command-line
zle -N edit-command-line

source ~/.config/zsh/func.zsh
source ~/.config/zsh/fzf-tab.zsh
source ~/.config/zsh/history.zsh
#====================pure=======================
print() {
  [ 0 -eq $# -a "prompt_pure_precmd" = "${funcstack[-1]}" ] || builtin print "$@";
} # 单行提示
#=====================RCM==========================
export DOTFILES_DIRS=$HOME/Documents/dotfiles
export RCRC=$HOME/.config/rcm/rcrc
#=======================mise========================
export MISE_DATA_DIR=$HOME/.mise
export PATH="$MISE_DATA_DIR/shims:$PATH"
#===================NAVI============================
eval "$(navi widget zsh)"
export NAVI_CONFIG=$HOME/.config/navi/config.yaml
#===================vivid===========================
export LS_COLORS="$(vivid generate ayu)"                 # vivid themes 预览
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}         # 颜色补全
#=====================other=========================
export BAT_THEME="TwoDark"           # bat 主题
#========================fzf========================
source $BREW_OPT/fzf/shell/completion.zsh 2> /dev/null # 将 .fzf.zsh 内容抽离出来
# https://vitormv.github.io/fzf-themes/
# https://github.com/junegunn/fzf/wiki/Color-schemes
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--ansi
--cycle
--multi
--info=inline-right
--pointer='▶'
--marker='✓'
--border=rounded
--color=dark
--bind=tab:down,shift-tab:up
--padding=0
--color=gutter:-1
--color=pointer:#ff87d7
--color=fg:-1,bg:-1,hl:#5fff87
--color=fg+:-1,bg+:-1,hl+:#ffaf5f
--color=info:#af87ff,prompt:#5fff87
--color=marker:#ff87d7,spinner:#ff87d7,header:#6272a4
'
export _ZO_FZF_OPTS=$FZF_DEFAULT_OPTS'
--no-sort
--border=none
--height 20%
--reverse'
#===================ALIAS===========================
alias cat='bat'
alias r='trash'
alias rm='trash'
alias c='clear'
alias ping='ping -c 5'
alias cp="cp -i"    # 防止拷贝覆盖
alias vi='nvim'
alias vim='nvim'
alias top='btm'
alias q='exit'
alias lip="curl cip.cc; curl ifconfig.me"
alias brewc="brew update && brew upgrade --formula && brew cleanup --prune 1 && brew autoremove" # mas upgrade
#===================BindKey=========================
bindkey '^f' vi-forward-word # 右移一个单词 [option]+[→] 和 [option]+[←]
bindkey '^b' vi-backward-word
# 使用 vim 编辑当前输入的命令
bindkey '\C-x\C-e' edit-command-line                  # control + x + control + e
bindkey "^[m" copy-prev-shell-word                    # option + m 快速复制前面的单词
bindkey '\ew' kill-region                             # [Esc-w] - Kill from the cursor to the mark  C-x C-y
bindkey -s '\el' 'ls\n'                               # [Esc-l] - run command: ls
