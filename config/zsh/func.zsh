#======================proxy=====================
function proxy() {
    export no_proxy="localhost,127.0.0.1"
    export http_proxy=http://127.0.0.1:7890
    export https_proxy=http://127.0.0.1:7890
    export all_proxy=socks5://127.0.0.1:7891
}
function unproxy(){
    unset http_proxy
    unset https_proxy
    unset all_proxy
    echo -e "关闭代理"
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
