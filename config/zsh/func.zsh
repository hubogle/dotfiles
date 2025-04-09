#======================proxy=====================
function proxy() {
    local cmd="$1"
    local proxy_addr="127.0.0.1:7890"
    local no_proxy_list="localhost,127.0.0.1,::1,*.local,*.localdomain,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12"

    case "$cmd" in
        on)
            export no_proxy="$no_proxy_list"
            export https_proxy="http://$proxy_addr"
            export http_proxy="http://$proxy_addr"
            export all_proxy="socks5://$proxy_addr"
            echo -e "\033[32m[✓] 已启用代理服务器\033[0m"
            ;;
        off)
            unset https_proxy http_proxy all_proxy no_proxy
            echo -e "\033[33m[!] 已关闭代理服务器\033[0m"
            ;;
        *)
            if [[ -n "$https_proxy" ]]; then
                echo -e "代理状态：\033[32m已启用 - $https_proxy\033[0m"
            else
                echo -e "代理状态：\033[31m已禁用\033[0m"
            fi
            ;;
    esac
}

#======================ssh=====================
ssh() {
    local original_term=$TERM
    TERM='xterm-256color'  # Set TERM for SSH sessions

    if [[ $(ps -p $(ps -p $$ -o ppid=) -o comm=) =~ tmux ]]; then
        local ssh_command="$@"
        local target_host=$(echo "$ssh_command" | awk -F'@' '{if (NF>1) print $2; else print $1}' | awk '{print $1}')
        tmux rename-window "$target_host"
        command ssh "$@"
        tmux rename-window "zsh"  # Reset window name after SSH
        [ $? -ne 0 ] && printf '\e[?1000l'
    else
        command ssh "$@"
    fi

    TERM=$original_term  # Restore original TERM after SSH
}

# https://gist.github.com/bbqtd/a4ac060d6f6b9ea6fe3aabe735aa9d95
update_terminfo () {
    local x ncdir terms
    ncdir="/opt/homebrew/opt/ncurses"
    terms=(alacritty-direct alacritty tmux tmux-256color)

    mkdir -p ~/.terminfo && cd ~/.terminfo

    if [ -d $ncdir ] ; then
        # sed : fix color for htop
        for x in $terms ; do
            $ncdir/bin/infocmp -x -A $ncdir/share/terminfo $x > ${x}.src &&
            sed -i '' 's|pairs#0x10000|pairs#32767|' ${x}.src &&
            /usr/bin/tic -x ${x}.src &&
            rm -f ${x}.src
        done
    fi
    cd - > /dev/null
}
