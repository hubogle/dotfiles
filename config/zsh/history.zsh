#====================历史记录========================
# https://z-shell.pages.dev/zh-Hans/docs/guides/customization
export HISTTIMEFORMAT="%F %T "
export SAVEHIST=100000          # 默认保存 10000 $HISTSIZE
export HISTSIZE=100000
setopt HIST_IGNORE_ALL_DUPS     # 从历史记录中删除较旧的重复条目
setopt HIST_IGNORE_DUPS         # 如果连续输入的命令相同，历史纪录中只保留一个
setopt HIST_REDUCE_BLANKS       # 在记录条目之前删除多余的空格
setopt HIST_IGNORE_SPACE        # 不要记录以空格开头的条目
setopt HIST_SAVE_NO_DUPS        # 不要在历史记录文件中写入重复条目
setopt APPEND_HISTORY           # 允许多个终端会话都附加到一个 zsh 命令历史记录
setopt EXTENDED_HISTORY         # 为历史纪录中的命令添加时间戳
setopt INC_APPEND_HISTORY       # 立即写入历史文件，不要在shell退出时写入
setopt SHARE_HISTORY            # 在所有会话之间共享历史记录
# setopt HIST_VERIFY              # 不要在历史扩展后立即执行
# setopt HIST_BEEP                # 访问不存在的历史记录时发出哔哔声
#===================其它===============================
setopt INTERACTIVE_COMMENTS     # 允许在交互模式中使用注释  例如：cmd #这是注释
setopt PUSHD_IGNORE_DUPS        # 不要将同一目录的多个副本推送到目录堆栈上
setopt auto_cd                  # 如果不是命令，则通过键入目录名称来使用 cd。
setopt no_beep                  # 不要在错误时发出哔哔声
setopt auto_list                # 自动列出模棱两可的完成选项。
setopt auto_pushd               # 使 cd 将旧目录推送到目录堆栈上。
setopt pushdminus               # 交换了 cd +1 和 cd -1 的含义；我们希望他们的意思与他们的意思相反。
setopt promptsubst              # 每次绘制提示时启用提示内的参数替换。
# setopt GLOB_COMPLETE          # Show autocompletion menu with globs
setopt MENU_COMPLETE            # 自动突出显示完成菜单的第一个元素
setopt AUTO_LIST                # 自动列出不明确完成的选项
setopt COMPLETE_IN_WORD         # 从一个词的两端完成的
# setopt glob_dots                # cd 提示所有隐藏文件
#======================================================
