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

## 插件依赖安装

`zi`插件、`NvChad`、`TMux`插件，放在 `hooks/pre-up` 下自动安装。

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

## 软件推荐

[Panda](https://bear.app/cn/alpha/) `Makrdown` 编辑器

## MAC 设置

* `Finder` 标题栏显示完整路径：`defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES;killall Finder`