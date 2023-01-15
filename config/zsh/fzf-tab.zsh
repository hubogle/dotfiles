#========================fzf-tab=======================
# fzf-tab 预览调整 https://github.com/Aloxaf/fzf-tab/wiki/Preview
# 分组调色 https://github.com/Aloxaf/fzf-tab/wiki/Configuration#group-colors
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:*' switch-group ',' '.'        # 来回切换分组展示
zstyle ':fzf-tab:*' prefix ''                   # 取消展示的 .
# zstyle ':fzf-tab:*' fzf-command fzf             # 默认使用 fzf
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup  # 使用 tmux 弹出窗口
zstyle ':fzf-tab:complete:cd:*' popup-pad 30 10
zstyle ':fzf-tab:*' fzf-flags '--color=hl:red'   # 输入中匹配字符的颜色
zstyle ':fzf-tab:*' default-color $'\033[38;5;115m'   # 没有组显示颜色
zstyle ':fzf-tab:*' single-group color          # 一组时显示颜色，默认配色
zstyle ':fzf-tab:*' show-group full             # 分组描述显示配置
FZF_TAB_GROUP_COLORS=(
    $'\033[94m' $'\033[32m' $'\033[33m' $'\033[35m' $'\033[31m' $'\033[38;5;27m' $'\033[36m' \
    $'\033[38;5;100m' $'\033[38;5;98m' $'\033[91m' $'\033[38;5;80m' $'\033[92m' \
    $'\033[38;5;214m' $'\033[38;5;165m' $'\033[38;5;124m' $'\033[38;5;120m'
)
zstyle ':fzf-tab:*' group-colors $FZF_TAB_GROUP_COLORS  # 分组时配色
#======================================================
#========================zstyle=======================o=
# 参考 https://github.com/sorin-ionescu/prezto/blob/master/modules/completion/init.zsh
zstyle ':completion:*' use-cache true                         # 对使用缓存的命令使用缓存
# zcompcache 存储路径配置
zstyle ':completion:*' cache-path "$HOME/.cache/zi/zcompcache"
zstyle ':completion:*' menu select                            # 允许您在菜单中选择
zstyle ':completion:*' complete-options true                  # 自动完成cd而不是目录堆栈的选项
zstyle ':completion:*' rehash true                            # 自动更新PATH条目
zstyle ':completion:*' verbose yes                            # 详细的完成结果

# 彩色补全菜单
# https://github.com/trapd00r/LS_COLORS  LS_COLORS环境变量
export LS_COLORS="$(vivid generate one-dark)"                 # vivid themes 预览
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}         # 颜色补全

#模糊匹配，错误校正
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'  # 大小写模糊，虚线值的智能匹配，例如f-b匹配foo-bar

#路径补全
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'     # //扩展为/.
zstyle ':completion::complete:*' '\\'
zstyle ':completion:*' accept-exact-dirs true    # 如果目录存在，不要尝试父路径补全

# 提示文件排序类型
zstyle ':completion:*' sort false             # 关闭默认排序
zstyle ':completion:*' file-sort modification # 修改日期对完成列表进行排序

#补全类型提示分组
zstyle ':completion:*' group-name ''          # 按类别将结果分组
zstyle ':completion:*' list-dirs-first true   # 将目录和文件分开
zstyle ':completion:*' format '[%d]'          # 添加这个才会分组
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
# zstyle ':completion:*:*:(vi|vim):*' ignored-patterns '*.(o|d)'  # 智能提示时忽略 o d 结尾文件

# 分页期间的漂亮消息
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

# scp file username@<TAB><TAB>:/<TAB>
zstyle ':completion:*:(ssh|scp|ftp|sftp):*' hosts $hosts
# zstyle ':completion:*:(ssh|scp|ftp|sftp):*' users $users
zstyle ':completion:*:(ssh|scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost ip6-allnodes ip6-allrouters
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*' 'ff02::1' 'ff02::2' '127.0.1.<->'

# 这里必须要忽略不必要的名称
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:*:*:*:users' ignored-patterns \
  adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
  dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
  hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
  mailman mailnull mldonkey mysql nagios \
  named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
  operator pcap postfix postgres privoxy pulse pvm quagga radvd \
  rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs '_*'
#====================================================
#=====================H-S-MW========================
# zstyle ":history-search-multi-word" page-size "8"                      # Number of entries to show (default is $LINES/3)
zstyle ":history-search-multi-word" highlight-color "fg=yellow,bold"   # Color in which to highlight matched, searched text (default bg=17 on 256-color terminals)
zstyle ":plugin:history-search-multi-word" synhl "yes"                 # Whether to perform syntax highlighting (default true)
zstyle ":plugin:history-search-multi-word" active "underline"          # Effect on active history entry. Try: standout, bold, bg=blue (default underline)
zstyle ":plugin:history-search-multi-word" check-paths "yes"           # Whether to check paths for existence and mark with magenta (default true)
zstyle ":plugin:history-search-multi-word" clear-on-cancel "no"        # Whether pressing Ctrl-C or ESC should clear entered query
#===================================================
