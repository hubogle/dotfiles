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
export PATH="$BREW_PATH:$PATH"
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
#======================ZI========================
source "${HOME}/.zi/bin/zi.zsh"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi

setopt prompt_subst             # 每次绘制提示时启用提示内的参数替换。

zi wait lucid for \
  OMZL::git.zsh \
  OMZP::git \
  OMZP::extract

zi light-mode for @sindresorhus/pure

zi wait lucid light-mode for \
  Aloxaf/fzf-tab \
  atuinsh/atuin

# https://wiki.zshell.dev/zh-Hans/docs/guides/syntax/for
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
        bindkey '^s' autosuggest-clear" \
    zsh-users/zsh-autosuggestions \
  blockf atpull'zi creinstall -q .' \
    zsh-users/zsh-completions

autoload -U edit-command-line
zle -N edit-command-line

# https://github.com/ajeetdsouza/zoxide
zi wait lucid light-mode for \
  atinit'export _ZO_DATA_DIR=$XDG_DATA_HOME/zoxide' \
  atload'eval "$(zoxide init zsh --cmd cd --hook pwd)"' \
  ajeetdsouza/zoxide

source ~/.config/zsh/func.zsh
source ~/.config/zsh/fzf-tab.zsh
source ~/.config/zsh/history.zsh
#====================pure=======================
print() {
  [ 0 -eq $# -a "prompt_pure_precmd" = "${funcstack[-1]}" ] || builtin print "$@";
} # 单行提示
#=====================RCM==========================
export DOTFILES_DIRS=$HOME/Documents/File/dotfiles
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
--border none
--color=dark
--color=fg:-1,bg:-1,hl:#5fff87
--color=fg+:-1,bg+:-1,hl+:#ffaf5f
--color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7
--color=marker:#ff87d7,spinner:#ff87d7,header:#6272a4
'
export _ZO_FZF_OPTS=$FZF_DEFAULT_OPTS'
--no-sort
--height 20%
--reverse'
#===================ALIAS===========================
alias ls='eza --classify=auto --color=always'
alias cat='bat'
alias r='trash'
alias rm='trash'
alias c='clear'
alias ping='ping -c 5'
alias cp="cp -i"    # 防止拷贝覆盖
alias l='eza --long --all --git --icons --time-style long-iso --colour-scale --header --group'
alias ll='eza --long --all --git --icons  --time-style iso --colour-scale --no-user --no-permissions --sort modified --reverse'
alias tree='eza --tree' # -L , --level=(depth)  递归的深度
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
