#====================历史记录========================
# https://wiki.zshell.dev/docs/guides/customization#history-optimization
export HISTTIMEFORMAT="%F %T "
export SAVEHIST=100000          # 默认保存 10000 $HISTSIZE
export HISTSIZE=100000
setopt append_history           # 允许多个终端会话都附加到一个 zsh 命令历史记录
setopt extended_history         # 显示历史中的时间戳
setopt hist_expire_dups_first   # 在修剪历史时首先过期重复事件
setopt hist_find_no_dups        # 不显示以前找到的事件。
setopt hist_ignore_all_dups     # 从历史记录中删除较旧的重复条目
setopt hist_ignore_dups         # 如果连续输入的命令相同，历史纪录中只保留一个
setopt hist_ignore_space        # 不要记录以空格开头的条目
setopt hist_reduce_blanks       # 在记录条目之前删除多余的空格
setopt hist_save_no_dups        # 不要将重复事件写入历史文件
setopt hist_verify              # 在展开历史记录时不立即执行
setopt inc_append_history       # 立即写入历史文件，而不是在shell退出时写入
setopt share_history            # 在shell的不同实例之间共享历史记录
# setopt HIST_BEEP                # 访问不存在的历史记录时发出哔哔声
#===================其它===============================
#https://wiki.zshell.dev/docs/guides/customization#other-tweaks
setopt auto_cd                  # 如果不是命令，则通过键入目录名称来使用 cd。
setopt auto_list                # 自动列出模棱两可的完成选项。
setopt auto_pushd               # 使 cd 将旧目录推送到目录堆栈上。
setopt interactive_comments     # 允许在交互模式中使用注释  例如：cmd #这是注释
setopt bang_hist                # Treat the '!' character, especially during Expansion.
setopt multios                  # Implicit tees or cats when multiple redirections are attempted.
setopt no_beep                  # 不要在错误时发出哔哔声
setopt PUSHD_IGNORE_DUPS        # 不要将同一目录的多个副本推送到目录堆栈上
setopt pushd_ignore_dups        # Don't push multiple copies directory onto the directory stack.
setopt pushd_minus              # 交换了 cd +1 和 cd -1 的含义；我们希望他们的意思与他们的意思相反。
# setopt GLOB_COMPLETE          # Show autocompletion menu with globs
setopt MENU_COMPLETE            # 自动突出显示完成菜单的第一个元素
setopt COMPLETE_IN_WORD         # 从一个词的两端完成的
# setopt glob_dots                # cd 提示所有隐藏文件
#======================================================
