# Alacritty + Tmux

## 使用

绑定快捷键：`Command, Option` 或者 `Command + Shift` 作为修饰键，部分快捷键与 `iTerm2.app` 绑定对应。

### 按键映射

终端输入 `xxd -psd` 属于映射的按键：
```shell
~ > xxd -psd
c
630a
```
`63` 代表 `c`，`0a` 代表回车，对应的 `hex` 为 `\0x63` 和 `\0x0a`。

## 按键绑定

* 新建
    * 垂直切分 `Command + D`
    * 水平切分 `Command + Shift + D`
    * 新建 `Windwos` `Command + T`
    * 新建 `Session` `Command + N`

* 关闭
    * 关闭 `Pane` `Command + W`
    * 关闭 `Windows` `Command + X`
