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
source ~/.config/zsh/fzf-tab.zsh
source ~/.config/zsh/history.zsh
#=====================P10k======================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#======================ZI========================
#https://z-shell.pages.dev/zh-Hans/docs/getting_started/installation/
source "${HOME}/.zi/bin/zi.zsh"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi

# 初始化自动完成
autoload -Uz compinit

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'  # 大小写模糊
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
zi light z-shell/F-Sy-H # 高亮插件

zi snippet OMZP::extract               # x 一键解压
zi snippet OMZL::git.zsh               # git alias
zi snippet OMZP::git                   # git alias
#=====================RCM===========================
export DOTFILES_DIRS=$HOME/Documents/File/dotfiles
export RCRC=$HOME/.config/rcm/rcrc
#=======================asdf=====================
export ASDF_CONFIG_FILE=$HOME/.config/asdfrc
source $BREW_OPT/asdf/libexec/asdf.sh
#=======================goEnv====================
export GO111MODULE=on # auto
export GOPROXY=https://goproxy.cn
export GOPATH=$(go env GOPATH)
export GOROOT=$(go env GOROOT)
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
#=====================zoxide=======================
# 更智能的CD命令，可跳转目录
export _ZO_DATA_DIR=$HOME/.cache/zoxide              # 可删除 zcompdump
eval "$(zoxide init zsh --cmd cd)"                   # 在调用 compinit 后添加上述行
#===================NAVI============================
eval "$(navi widget zsh)"
export NAVI_CONFIG=$HOME/.config/navi/config.yaml
#===================histdb==========================
HISTDB_TABULATE_CMD=(sed -e $'s/\x1f/\t/g')
autoload -Uz add-zsh-hook
if [[ -f "$HISTDB_FILE" ]]; then
  _histdb_query () { # https://github.com/larkery/zsh-histdb/issues/27
      sqlite3 "${HISTDB_FILE}" ".timeout 100
  $@"
      [[ "$?" -ne 0 ]] && echo "error in $@"
  }
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
  selected=( $(histdb --host --sep 999 | awk -F'999' '{ if (!seen[$5]++) {print $5} }' |
    FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m --tac" fzf) )
  LBUFFER=$selected
  zle redisplay
  typeset -f zle-line-init >/dev/null && zle zle-line-init
  return $ret
} # 在 fzf 中选中命令命令 control + d 执行删除
zle     -N   histdb-fzf-widget
bindkey '^R' histdb-fzf-widget
#===================BindKey=========================
bindkey '^f' vi-forward-word # 右移一个单词 [option]+[→] 和 [option]+[←]
bindkey '^b' vi-backward-word
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
#proxy
#==============================================
