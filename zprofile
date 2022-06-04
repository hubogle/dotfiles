### openssl ###
#export PATH="/opt/homebrew/opt/openssl@1.1/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/openssl@1.1/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@1.1/include"

### zsh-syntax-highlighting ### 命令高亮
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters

### zsh-autosuggestions ### 命令补全
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh


### ncurses ###
#export PATH="/opt/homebrew/opt/ncurses/bin:$PATH"	# zsh 下载携带的 ncurses
#export LDFLAGS="-L/opt/homebrew/opt/ncurses/lib"
#export CPPFLAGS="-I/opt/homebrew/opt/ncurses/include"

### ruby ###
#export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
#export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
#export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"

### sqlite ###
#export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"
#export LDFLAGS="-L/opt/homebrew/opt/sqlite/lib"
#export CPPFLAGS="-I/opt/homebrew/opt/sqlite/include"

### readline ###
#export LDFLAGS="-L/opt/homebrew/opt/readline/lib"
#export CPPFLAGS="-I/opt/homebrew/opt/readline/include"

### perl ###
#eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"

### ruby ###
#export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
#export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"

### mysql-client ###
#export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
#export LDFLAGS="-L/opt/homebrew/opt/mysql-client/lib"
#export CPPFLAGS="-I/opt/homebrew/opt/mysql-client/include"
#export PKG_CONFIG_PATH="/opt/homebrew/opt/mysql-client/lib/pkgconfig"

### node ### 依赖 icu4c
#export PATH="/opt/homebrew/opt/icu4c/bin:$PATH"
#export PATH="/opt/homebrew/opt/icu4c/sbin:$PATH"
#export LDFLAGS="-L/opt/homebrew/opt/icu4c/lib"
#export CPPFLAGS="-I/opt/homebrew/opt/icu4c/include"
#export PKG_CONFIG_PATH="/opt/homebrew/opt/icu4c/lib/pkgconfig"

### zlib ###
#export LDFLAGS="-L/opt/homebrew/opt/zlib/lib"
#export CPPFLAGS="-I/opt/homebrew/opt/zlib/include"
#export PKG_CONFIG_PATH="/opt/homebrew/opt/zlib/lib/pkgconfig"

### fzf ###

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
### fzf 界面展示
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --preview '(highlight -O ansi {} || cat {} || tree -C {}) 2> /dev/null | head -500'"

### homebrew ###
#alias brewc="brew update && brew upgrade && brew upgrade --cask --greedy && brew cleanup --prune 1 && brew doctor"
#alias brewc="brew update && brew upgrade && brew cleanup --prune 1 && brew doctor"
alias brewc="brew update && brew upgrade --formula && brew cleanup --prune 1"
export HOMEBREW_NO_AUTO_UPDATE=true     # 自动更新关闭
#export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

### pyenv ###
#依赖 openssl\readline\zlib\sqlite\xz
export PYENV_ROOT="$HOME/.pyenv"
#export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

#if command -v pyenv 1>/dev/null 2>&1; then
#  eval "$(pyenv init -)"
#fi

alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'    # brew doctor 问题


### goenv GO 环境配置###
# brew 手动安装的最新版本
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/shims:$PATH"
export GOENV_GOPATH_PREFIX="$GOENV_ROOT/go"
eval "$(goenv init -)"
#export GO111MODULE="on"    # 强制使用 go Mod
#export GOPROXY=https://goproxy.cn,direct

### pyenv-virtualenv ###
#if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
export PYENV_VIRTUALENV_DISABLE_PROMPT=1    # 取消提醒

### navi 备忘录 ###
# source "$(navi widget zsh)" 设置快捷键
_call_navi() {
  local selected
  if [ -n "$LBUFFER" ]; then
    if selected="$(printf "%s" "$(navi --print --fzf-overrides '--no-select-1' --query "${LBUFFER}" </dev/tty)")"; then
      LBUFFER="$selected"
    fi
  else
    if selected="$(printf "%s" "$(navi --print </dev/tty)")"; then
      LBUFFER="$selected"
    fi
  fi
  zle redisplay
}

zle -N _call_navi

bindkey '^g' _call_navi
export NAVI_PATH="/Users/hubo/.cheat"
#export NAVI_PATH="/Users/hubo/Library/Application Support/navi/cheats/denisidoro__cheats:/Users/hubo/.cheat"    # 设置目录

### 代理 ###
function proxy() {
    export no_proxy="localhost,127.0.0.1"
    export http_proxy=http://127.0.0.1:7890
    export https_proxy=http://127.0.0.1:7890
    #export all_proxy=socks5://127.0.0.1:7891
}
function unproxy(){
    unset http_proxy
    unset https_proxy
    unset all_proxy
    echo -e "关闭代理"
}
proxy


# 设置标题栏
DISABLE_AUTO_TITLE="true"

### 快捷键替换 ###
HIST_STAMPS="yyyy-mm-dd"	# 添加时间
#alias vi='mvim -v'
#alias vim='mvim -v'
alias mvi=mvim
alias cp="cp -i"    # 防止拷贝覆盖
alias untar='tar -zxvf' # 解压tar文件
alias wget='wget -c'    # 下载文件
alias ping='ping -c 5'
alias c='clear'
alias sha='shasum -a 256'
alias lbys='ls -alhS'   # 文件按大小排序
alias lbyt='ls -alht'
alias ip="curl cip.cc"
alias jsonformat='pbpaste | jq . | pbcopy'     # json 格式化 pbpaste | jq "." | pbcopy; pbpaste | jq;
alias jsonline='pbpaste | jq -c . | pbcopy'    # json 压缩
#alias rm="safe-rm"    # rm删除到回收站
export _Z_CMD=j	# 将 z 命令更改为 j

alias rm=trash  # rm 删除到回收站
alias r=trash
alias rl='ls ~/.Trash'  # 列出回收站文件
alias ur=undelfile  # 恢复删除文件
#trash()
#{  
#    mv -f $@ ~/.trash/
#}
undelfile()
{
    mv -i ~/.trash/$@ ./
}
