#======================proxy=====================
function proxy() {
    local cmd="$1"
    local http_addr="127.0.0.1"
    local http_port="1080"
    local socks_port="1080"
    local service="Wi-Fi"
    local proxy_addr="$http_addr:$http_port"
    local no_proxy_list="localhost,127.0.0.1,::1,*.local,*.localdomain,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12"

    case "$cmd" in
        on)
            # Terminal proxy
            export no_proxy="$no_proxy_list"
            export https_proxy="http://$proxy_addr"
            export http_proxy="http://$proxy_addr"
            export all_proxy="socks5://$http_addr:$socks_port"

            # System (Wi-Fi) proxy
            sudo networksetup -setwebproxy "$service" $http_addr $http_port
            sudo networksetup -setsecurewebproxy "$service" $http_addr $http_port
            sudo networksetup -setwebproxystate "$service" on
            sudo networksetup -setsecurewebproxystate "$service" on
            sudo networksetup -setsocksfirewallproxy "$service" $http_addr $socks_port
            sudo networksetup -setsocksfirewallproxystate "$service" on

            echo -e "\033[32m[✓] Proxy enabled (Terminal + Wi-Fi) [HTTP:$http_port, SOCKS:$socks_port]\033[0m"
            ;;
        off)
            # Terminal proxy
            unset https_proxy http_proxy all_proxy no_proxy

            # System (Wi-Fi) proxy
            sudo networksetup -setwebproxystate "$service" off
            sudo networksetup -setsecurewebproxystate "$service" off
            sudo networksetup -setsocksfirewallproxystate "$service" off

            echo -e "\033[33m[!] Proxy disabled (Terminal + Wi-Fi)\033[0m"
            ;;
        *)
            if [[ -n "$https_proxy" ]]; then
                echo -e "Terminal proxy: \033[32mON\033[0m ($https_proxy)"
            else
                echo -e "Terminal proxy: \033[31mOFF\033[0m"
            fi

            echo "--- System proxy status (Wi-Fi) ---"
            local http_state=$(networksetup -getwebproxy "$service" | awk '/^Enabled:/ {print $2}')
            local https_state=$(networksetup -getsecurewebproxy "$service" | awk '/^Enabled:/ {print $2}')
            local socks_state=$(networksetup -getsocksfirewallproxy "$service" | awk '/^Enabled:/ {print $2}')

            if [[ "$http_state" == "Yes" ]]; then
                echo -e "HTTP Proxy:   \033[32mON\033[0m"
            else
                echo -e "HTTP Proxy:   \033[31mOFF\033[0m"
            fi

            if [[ "$https_state" == "Yes" ]]; then
                echo -e "HTTPS Proxy:  \033[32mON\033[0m"
            else
                echo -e "HTTPS Proxy:  \033[31mOFF\033[0m"
            fi

            if [[ "$socks_state" == "Yes" ]]; then
                echo -e "SOCKS Proxy:  \033[32mON\033[0m"
            else
                echo -e "SOCKS Proxy:  \033[31mOFF\033[0m"
            fi
            ;;
    esac
}


export no_proxy="localhost,127.0.0.1,::1,*.local,*.localdomain,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12"
export https_proxy="http://127.0.0.1:1080"
export http_proxy="http://127.0.0.1:1080"
export all_proxy="socks5://127.0.0.1:1080"


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
