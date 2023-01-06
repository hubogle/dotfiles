# Dotfile 恢复指南

## 1.brew 安装

1. [Command Line Tools](https://developer.apple.com/download/all/?q=Command) 官网安装，或命令安装 `xcode-select --install`
2. [Brew 官网](https://brew.sh/index_zh-cn) `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
4. 安装三方未知来源：`sudo spctl --master-disable`
5. 设置主机名 `sudo scutil --set HostName "MacX"`

* 备份：`brew bundle dump --force --file="~/Documents/File/dotfiles/Brewfile"`

## 2.修改自定义配置

1. `config/git/config` 修改`git username` && `email`
2. 修改`Brewfile`, 增删自定义插件及软件
3. `hooks/pre-up/init` 注释 `histdb`相关命令 或 修改`histdb`相关配置


## 3.使用rcm恢复文件及配置
1. `brew install rcm`
2. 修改 `zshrc` 中的 `DOTFILES_DIRS` 路径。
3. `brew` 恢复安装：`brew bundle --file="~/Documents/File/dotfiles/Brewfile"`
4. 执行 `rcup` 恢复配置文件。

---

## QA
Q: tmux 插件下载失败
A: prefix + r 或者 tmux source ~/.config/tmux/tmux.conf 重载配置
   prefix + I 重新下载插件

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
3. `Debug` 调试 `sudo /usr/sbin/DevToolsSecurity --enable`
---

## RCM 使用

- `mkrc` – 将文件转换为由 `rcm` 管理的隐藏文件
- `lsrc` – 列出由 `rcm` 管理的文件
- `rcup` – 同步由 `rcm` 管理的隐藏文件
- `rcdn` – 删除 `rcm`  管理的所有符号链接
---

## zsh 命令技巧

* `fc` 在编辑器中编辑上条命令，保存推出即执行

* `control + r` 搜索历史命令
* `control + a` 移到行首
* `control + e` 移到行尾
* `control + b` 移动到当前单词的词首
* `control + f` 移动到当前单词的词尾
* `control + d` 删除光标位置的字符（delete）
* `control + w` 删除光标前面的单词
* `control + y` 在光标位置粘贴文本
* `control + k` 剪切光标位置到行尾的文本
* `control + u` 剪切光标位置到行首的文本
* `option + d` 剪切光标位置到词尾的文本
* `option + Backspace` 剪切光标位置到词首的文本。
