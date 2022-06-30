# Dotfile 恢复指南
## RCM 使用

- `mkrc` – 将文件转换为由 `rcm` 管理的隐藏文件
- `lsrc` – 列出由 `rcm` 管理的文件
- `rcup` – 同步由 `rcm` 管理的隐藏文件
- `rcdn` – 删除 `rcm`  管理的所有符号链接
---
## brew 安装

1. [Command Line Tools](https://developer.apple.com/download/all/?q=Command) 官网安装，或命令安装 `xcode-select --install`
2. [Brew 官网](https://brew.sh/index_zh-cn) `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
3. `brew` 恢复安装：`brew bundle --file="~/Documents/File/dotfiles/Brewfile"`
4. 安装三方未知来源：`sudo spctl --master-disable`
5. 设置主机名 `sudo scutil --set HostName "MacX"`
6. `cp ~/Documents/File/dotfiles/zshrc ~/.zshrc`

* 备份：`brew bundle dump --force --file="~/Documents/File/dotfiles/Brewfile"`
---
## 插件依赖安装

[im-select](https://github.com/daipeihust/im-select/tree/master/im-select-mac/out) 切换输入法

`zi`插件、`NvChad`、`Tmux`插件、`im-select`，放在 `hooks/pre-up/init` 下自动安装。

---
## 软件推荐
[Panda](https://bear.app/cn/alpha/) `Makrdown` 编辑器

---

## 系统重装

1. `iCloud` 关闭照片同步，打开桌面和文稿文件夹
2. 辅助功能触摸板打开三指拖拽

### 图标排列

```shell
defaults write com.apple.dock springboard-columns -int 8

defaults write com.apple.dock springboard-rows -int 7

defaults write com.apple.dock ResetLaunchPad -bool TRUE # 重置Launchpad

killall Dock
```

---
## MAC 设置
[Mac 命令](https://github.com/mathiasbynens/dotfiles/blob/main/.macos)

* `Finder` 标题栏显示完整路径：`defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES;killall Finder`
* 禁止生成 `DS_store` 文件，重启生效：`defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE`
* 所有显示器上显示cmd+应用程序切换器：`defaults write com.apple.Dock appswitcher-all-displays -bool true;killall Dock`
* `hammerspoon` 路径配置：`defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"`
* `Vscode VIM` 连点配置 `defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false`
* 全局连点配置 `defaults delete -g ApplePressAndHoldEnabled`
