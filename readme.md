# Dotfile 恢复指南

1. `zsh` 采用 `P10k` + [zi](https://wiki.zshell.dev/zh-Hans/)
2. `vim` 采用 `neovim` + [NvChad](https://nvchad.com)
5. `histdb` 同步不同设备的 `zsh` 历史命令 [zsh-histdb](https://github.com/larkery/zsh-histdb)
3. 通过 `hammerspoon` + [im-select](https://github.com/daipeihust/im-select/tree/master/im-select-mac/out) 实现 `App` 输入法自动切换。
4. `brew` 所有软件及 `cli` 通过 `Brewfile` 管理。
5. `rcm` 管理所有配置文件，所有配置尽量都放在 `~/.config` 下管理。
6. `osx.sh` 文件为系统相关配置。

`zi`插件、`NvChad`、`Tmux`插件、`im-select`，在执行 `rcup` 后会执行 `hooks/pre-up/init`。

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
2. [Brew 官网](https://brew.sh/index_zh-cn) 安装命令 `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
3. 安装三方未知来源：`sudo spctl --master-disable`

* 备份：`brew bundle dump --force --file="~/Documents/File/dotfiles/Brewfile"`

## 2.自定义配置

恢复软件及配置前，需要自定义配置。

1. `hooks/pre-up/init` 注释 `histdb`相关命令 或 修改`histdb`相关配置。
2. 自行注释 `hooks/post-up/rsync` 里的命令。
3. 修改`Brewfile`, 增删自定义插件及软件
4. `config/git/config` 修改`git username` && `email`
---


## 3.使用rcm恢复文件及配置
1. `brew install rcm`
2. 修改 `zshrc` 中的 `DOTFILES_DIRS` 路径。
3. `brew` 恢复安装：`brew bundle --file="~/Documents/File/dotfiles/Brewfile"`
4. 执行 `rcup` 恢复配置文件。

## 4.开发语言版本管理
统一管理开发语言的版本[mise](https://mise.jdx.dev/)。

---

## QA
* Q: tmux 插件下载失败，或未生效
* A: 手动删除 `.config/tmux/plugins` 目录下除 `tpm` 的所有目录，重新下载插件。
* Q: 判断终端和 `tmux` 是否为 `256` 色彩
* A: `curl https://raw.githubusercontent.com/JohnMorales/dotfiles/master/colors/24-bit-color.sh | bash`
---

## 推荐系统配置

1. `iCloud` 关闭照片同步，打开桌面和文稿文件夹
2. 辅助功能触摸板打开三指拖拽
3. `Debug` 调试 `sudo /usr/sbin/DevToolsSecurity --enable`
---

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
