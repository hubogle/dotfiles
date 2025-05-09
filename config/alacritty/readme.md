# Alacritty + Tmux

## 使用

绑定快捷键：`Command, Option` 或者 `Command + Shift` 作为修饰键，部分快捷键与 `iTerm2.app` 绑定对应。

### 按键映射
[键盘按键代码](https://www.lizhanglong.com/Tools/KeyCode)
终端输入 `xxd -psd` 属于映射的按键：
```shell
~ > xxd -psd
c
630a
```
`63` 代表 `c`，`0a` 代表回车，对应的 `hex` 为 `\0x63` 和 `\0x0a`。

## 按键绑定
* 按键匹配
    * `Control|Command + U` 快速打开 `url`
    * `Control|Command + O` 快速拷贝 `url`
    * `Control|Command + I` 快速 `commit id`

* 新建
    * 垂直切分 `Command + D`
    * 水平切分 `Command + Shift + D`
    * 新建 `Windwos` `Command + T`
    * 新建 `Session` `Command + N`

* 关闭
    * 关闭 `Pane` `Command + W`
    * 关闭 `Windows` `Command + Shift + W`

* 访问 `Pane`: `Command` + "方向键"
* 访问 `Windows`: `Command` + "数字键"
* 切换 `Windows`: `Command` + `[]`
* 下个 `Windows`: `Option` + `Tab`
* 上个 `Windows`: `Option` + `Shift` + `Tab`
* 调整大小: `Command` + `Shift` + "方向键"
* 缩放窗口 `Command` + `Z`
* 调整窗口布局 `Command` + `Shift` + `Z`
* 字体放大 `Command` + `+`
* 字体缩小 `Command` + `-`
* 字体重置 `Command` + `0`
* 同步输入 `Command` + `I`
* 最近访问窗口 `Command` + `E`
* 删除整行 `Command` + `Delete`
* 行首 `Command` + `Left`
* 行尾 `Command` + `Right`
* 广播输入 `Command` + `Shift` + `I`
* 输入 `tmux` 命令 `Command` + `I`
* 向上搜索 `Command` + `F`
* 向下搜索 `Command` + `Shift` + `F`
* 输入 `tmux` 命令 `Command` + `I`
* 同步 `panel` 输入 `Command` + `Shift` + `I`

## 服务器配置

链接服务器直接登录 `tmux`：`ssh tencent`
使用其其它终端：`ssh -oRemoteCommand=none tencent`

```
Host tencent
    HostName        127.0.0.1
    User            root
    IdentityFile    ~/.ssh/id_rsa
    RequestTTY Yes
    RemoteCommand tmux new-session -A -D -X -s main /bin/bash
```
