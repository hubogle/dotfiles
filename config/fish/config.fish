if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -U fish_greeting "" # 取消问候语
set -gx ALL_PROXY socks5://127.0.0.1:7891 # 代理端口
set -Ux http_proxy http://127.0.0.1:7890
set -Ux https_proxy http://127.0.0.1:7890
set -Ux no_proxy "localhost,127.0.0.1,172.16.0.0/12,192.168.0.0/16,baidu.com"

###
alias brewc="brew update && brew upgrade --formula && brew cleanup --prune 1 && brew autoremove"
export HOMEBREW_NO_AUTO_UPDATE=true     # 自动更新关闭
set -x PATH /opt/homebrew/bin /opt/homebrew/sbin $PATH
###


### pyenv ###
#set -Ux PYENV_ROOT $HOME/.pyenv
#set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths
set -gx PATH '/Users/hubo/.pyenv/shims' $PATH

# pyenv init
if command -v pyenv 1>/dev/null 2>&1
  pyenv init - | source
end
alias brew="env PATH=(string replace (pyenv root)/shims '' \"\$PATH\") brew"

### goenv ###
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/shims:$PATH"
export GOENV_GOPATH_PREFIX="$GOENV_ROOT/go"
#eval "$(goenv init -)"
export GO111MODULE="on"    # 强制使用 go Mod
export GOPROXY=https://goproxy.cn,direct

### cheat ###
export NAVI_PATH="/Users/hubo/.cheat"

alias mvi=mvim
alias cp="cp -i"  # 防止拷贝覆盖
alias ping="ping -c 5"
alias c=clear
alias ls=exa
alias ip="curl cip.cc"
alias l=ll
alias rm=trash  # rm 删除到回收站
alias r=trash
alias rl='ls ~/.Trash'  # 列出回收站文件
alias ur=undelfile  # 恢复删除文件
alias s3uat="s3cmd -c ~/.s3cmd/uat"
alias s3prod="s3cmd -c ~/.s3cmd/prod"
alias s3test="s3cmd -c ~/.s3cmd/test"

### git alias ###
alias g=git
alias gaa='git add --all'
alias gb='git branch'
alias gba='git branch -a'
alias gl='git pull'
alias gcd='git checkout develop'
alias gcm='git checkout master'
alias gst='git status'
alias gstp='git stash pop'

# fzf 预览配置
#alias fzfp="fd -t f | fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
alias fzf="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"

#starship init fish | source
#thefuck --alias | source 
