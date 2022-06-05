# 系统环境配置

## brew 安装
[Brew 官网](https://brew.sh/index_zh-cn)
[Command Line Tools 安装](https://developer.apple.com/download/all/?q=Command)

1. `Command Line` 安装后然后在系统软件更新检查。
2. 设置终端临时代理
3. `brew` 安装 `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
4. `brew` 安装 `brew install zsh git`
5. `sudo vi /etc/shells` 追加 `/opt/homebrew/bin/zsh`
6. 切换 `zsh`：`chsh -s /opt/homebrew/bin/zsh`
7. 安装三方未知来源：`sudo spctl --master-disable`
8. `brew` 恢复安装：`brew bundle --file="~/Documents/File/dotfiles/Brewfile"`

* 备份：`brew bundle dump --force --file="~/Documents/File/dotfiles/Brewfile"`

## zi 安装

1. `zi_home="${HOME}/.zi" && mkdir -p $zi_home`
2. `git clone https://github.com/z-shell/zi.git "${zi_home}/bin"`

## NvChad 安装

`git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 ; nvim`

## RCM 恢复 dotfiles

1. `echo "~/Documents/File/dotfiles/Brewfile" >> ~/.rcrc`
2. `rcup` 同步隐藏文件

## Tmux 恢复

三方插件库：`git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm`

## Chrome 禁止更新

`sudo vi /Library/Preferences/com.google.Keystone.plist`

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>updatePolicies</key>
        <dict>
          <key>global</key>
          <dict>
            <key>UpdateDefault</key>
            <integer>3</integer>
            <key>DownloadPreference</key>
            <string>cacheable</string>
          </dict>
          <key>com.google.Chrome</key>
          <dict>
            <key>UpdateDefault</key>
            <integer>2</integer>
            <key>TargetVersionPrefix</key>
            <string>62.</string>
          </dict>
	    <key>com.google.drivefs</key>
          <dict>
            <key>UpdateDefault</key>
            <integer>2</integer>
           </dict>
        </dict>
</dict>
</plist>
```
[官方文档](https://support.google.com/chrome/a/answer/7591084)

## FZF 安装

[fzfP提示](https://github.com/kevinhwang91/fzf-tmux-script/blob/main/popup/fzfp)

## 软件推荐

[Panda](https://bear.app/cn/alpha/) `Makrdown` 编辑器
