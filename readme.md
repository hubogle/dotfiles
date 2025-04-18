# Dotfile 恢复指南

1. `zsh` 采用 [zi](https://wiki.zshell.dev/zh-Hans/)
2. `vim` 采用 `neovim` + [NvChad](https://nvchad.com)
3. `alacritty` + `tmux` 终端输入管理。
4. 通过 `hammerspoon` 实现 `App` 输入法自动切换。
5. `brew` 所有软件及 `cli` 通过 `Brewfile` 管理。
6. `rcm` 管理所有配置文件，所有配置尽量都放在 `~/.config` 下管理。
7. `osx.sh` 文件为系统相关配置。

`NvChad`、`im-select`，在执行 `rcup` 后会执行 `hooks/pre-up/init`。

## 软件升级

1. `zi update --all` 更新 `zsh` 的插件和片段。
2. `brew update && brew upgrade --formula` 升级 `brew` 安装的软件。
3. `brew cu -af` 升级 `cask` 软件。

## RCM 使用

- `mkrc` – 将文件转换为由 `rcm` 管理的隐藏文件
- `lsrc` – 列出由 `rcm` 管理的文件
- `rcup` – 同步由 `rcm` 管理的隐藏文件
- `rcdn` – 删除 `rcm`  管理的所有符号链接
---

## 1.brew 安装

1. [Command Line Tools](https://developer.apple.com/download/all/?q=Command) 官网安装，或命令安装 `xcode-select --install`
2. [Brew 官网](https://brew.sh/) 安装命令 `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
3. 安装三方未知来源：`sudo spctl --master-disable`

* 备份：`brew bundle dump --force --file="~/Documents/dotfiles/Brewfile"`

## 2.自定义配置

恢复软件及配置前，需要自定义配置。

1. 修改 `Brewfile` 文件增删自定义插件及软件。
---

## 3.brew 恢复软件安装
1. 在 `dotfile` 文件夹中执行 `/opt/homebrew/bin/brew bundle --file=$PWD/Brewfile`

## 4.使用rcm配置
1. `export PATH="/opt/homebrew/bin:$PATH" && brew install rcm`
2. 在 `dotfile` 文件夹中执行 `rcup -d $PWD` 恢复配置文件。

## 5.zi 手动安装
[ZI 官网](https://wiki.zshell.dev/zh-Hans/)

安装命令 `sh -c "$(curl -fsSL get.zshell.dev)" --`
依次执行以下命令：
* `exec zsh -il`
* `zi self-update`

## 6.开发语言版本管理
统一管理开发语言的版本[mise](https://mise.jdx.dev/)。

* `mise install` 安装

---

## QA
* Q: 判断终端和 `tmux` 是否为 `256` 色彩
* A: `curl https://raw.githubusercontent.com/JohnMorales/dotfiles/master/colors/24-bit-color.sh | bash`

* Q: 修改电脑名称 `HostName` 查看
* A: `sudo scutil --set HostName name`

* Q: `CursorUIViewService` 未响应
* A: `sudo defaults write /Library/Preferences/FeatureFlags/Domain/UIKit.plist redesigned_text_cursor -dict-add Enabled -bool NO`

## Nvchad 重复安装
[NvChad](https://nvchad.com/docs/quickstart/install) 安装之前卸载。

```shell
rm -rf ~/.config/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.local/share/nvim
```
---

## 推荐系统配置

1. `iCloud` 关闭照片同步，打开桌面和文稿文件夹
2. 辅助功能 》指针控制 》触摸板选项 》触摸板打开三指拖拽
3. `[System Settings] > [Keyboard]`，选中 `[Keyboard navigation]`
4. `Debug` 调试 `sudo /usr/sbin/DevToolsSecurity --enable`
5. `Edge` 禁用 `WebRTC`, `[about:flags] > WebRTC`
---

[cheatsheet](https://github.com/skywind3000/awesome-cheatsheets/tree/master?tab=readme-ov-file)

## zsh 命令技巧

* `fc` 在编辑器中编辑上条命令，保存推出即执行
* `option + d` 剪切光标位置到词尾的文本
* `option + Backspace` 剪切光标位置到词首的文本。
* `autocd`输入文件名回车自动进入。

## 移动光标快捷键

* `Control + a` 移到行首
* `Control + e` 移到行尾
* `Control + p` 上移一行
* `Control + e` 下移一行
* `Control + b` 移动到当前单词的词首
* `Control + f` 移动到当前单词的词尾
* `Control + l` 清屏操作
* `Control + r` 查找历史
* `Control + y` 在光标位置粘贴文本

## 文字删除快捷键

* `Control + h` 删除光标前一个字符
* `Control + d` 删除光标后面的一个字符
* `Control + w` 删除光标前面的一个单词
* `Control + u` 删除这条命令所有的单词
* `Control + k` 删除从光标开始到一行结尾的所有字符
* `Control + q` 删除当前命令并在下次使用时再次显示

# 配置目录介绍

```text
export XDG_DATA_HOME=$HOME/.local/share   # 存储用户数据文件
export XDG_STATE_HOME=$HOME/.local/state  # 应用程序状态信息会更新
export XDG_CONFIG_HOME=$HOME/.config      # 应用程序的配置文件
export XDG_CACHE_HOME=$HOME/.cache        # 用于存储缓存文件
```

```text
├──  share
│   ├──  atuin       # 搜索历史
│   ├──  nvim
│   ├──  terminfo
│   ├──  tig
│   │   └──  history
│   └──  zoxide      # 移动到 ~/.zi/polaris/share
│
└──  state
    ├──  ipython
    ├──  less
    │   └──  history
    ├──  mise
    │   ├──  hints
    │   ├──  tracked-configs
    │   └──  trusted-configs
    ├──  mycli
    ├──  nvim
    └──  zsh
        └──  history
```
