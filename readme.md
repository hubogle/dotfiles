# 系统环境配置

## brew 安装
[Brew 官网](https://brew.sh/index_zh-cn)
[Command Line Tools 安装](https://developer.apple.com/download/all/?q=Command)

1. `Command Line` 安装后然后在系统软件更新检查。
2. 设置终端临时代理
3. `brew` 安装 `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
4. 安装三方未知来源：`sudo spctl --master-disable`
5. `brew` 恢复安装：`brew bundle --file="~/Documents/File/dotfiles/Brewfile"`

* 备份：`brew bundle dump --force --file="~/Documents/File/dotfiles/Brewfile"`

## zi 安装

1. `zi_home="${HOME}/.zi" && mkdir -p $zi_home`
2. `git clone https://github.com/z-shell/zi.git "${zi_home}/bin"`

## RCM 恢复 dotfiles

1. `echo "~/Documents/File/dotfiles/Brewfile" >> ~/.rcrc`
2. `rcup` 同步隐藏文件

## Tmux 恢复

1. 三方插件：`git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`

## NvChad 安装

`git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 ; nvim`

## 软件推荐

[Panda](https://bear.app/cn/alpha/) `Makrdown` 编辑器
