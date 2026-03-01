if status is-interactive
    set -gx EDITOR nvim
    set -gx BROWSER firefox
    set -gx PAGER less
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
    set -gx TERM xterm-256color
    set -gx COLORTERM truecolor
    set -gx CLICOLOR 1

    fish_vi_key_bindings
    set fish_greeting

    set fish_color_normal normal
    set fish_color_command 00d7ff
    set fish_color_quote a8cc8c
    set fish_color_redirection ff6b9d
    set fish_color_end ff6b9d
    set fish_color_error ff5555
    set fish_color_param d7d7d7
    set fish_color_comment 6272a4
    set fish_color_match --background=brblue
    set fish_color_selection white --bold --background=brblack
    set fish_color_search_match bryellow --background=brblack
    set fish_color_history_current --bold
    set fish_color_operator ff79c6
    set fish_color_escape 8be9fd
    set fish_color_cwd green
    set fish_color_cwd_root red
    set fish_color_valid_path --underline
    set fish_color_autosuggestion 6272a4
    set fish_color_user brgreen
    set fish_color_host normal

    alias ls 'eza --color=always --group-directories-first --icons'
    alias ll 'eza -alF --color=always --group-directories-first --icons'
    alias la 'eza -a --color=always --group-directories-first --icons'
    alias lt 'eza -aT --color=always --group-directories-first --icons'
    alias l. 'eza -a | grep -E "^\."'
    alias g 'git'
    alias gs 'git status -sb'
    alias gl 'git log --oneline --graph --decorate --all'
    alias gd 'git diff --color=always'
    alias sysinfo 'fastfetch'
    alias weather 'curl -s "wttr.in?format=3"'
    alias myip 'curl -s ifconfig.me'
    alias ports 'netstat -tuln'
    alias cat 'bat --style=numbers,changes,header'
    alias less 'bat --paging=always'
    alias .. 'cd ..'
    alias ... 'cd ../..'
    alias .... 'cd ../../..'
    alias htop 'btop'
    alias df 'df -h'
    alias du 'du -h'
    alias free 'free -h'
    alias grep 'grep --color=auto'
    alias mkdir 'mkdir -pv'
    alias wget 'wget -c'
    alias reload 'source ~/.config/fish/config.fish'

    function cd
        builtin cd $argv
        and ls
    end

    function extract
        switch $argv[1]
            case '*.tar.bz2'; tar xjf $argv[1] ;;
            case '*.tar.gz'; tar xzf $argv[1] ;;
            case '*.bz2'; bunzip2 $argv[1] ;;
            case '*.rar'; unrar x $argv[1] ;;
            case '*.gz'; gunzip $argv[1] ;;
            case '*.tar'; tar xf $argv[1] ;;
            case '*.tbz2'; tar xjf $argv[1] ;;
            case '*.tgz'; tar xzf $argv[1] ;;
            case '*.zip'; unzip $argv[1] ;;
            case '*.7z'; 7z x $argv[1] ;;
            case '*'; echo "Unknown archive format" ;;
        end
    end

    function update
        echo "🔄 Updating system packages..."
        if command -v pacman >/dev/null
            sudo pacman -Syu
        else
            echo "Package manager not recognized"
        end
    end

    function netinfo
        echo "🌐 Network Information:"
        echo "External IP: "(curl -s ifconfig.me)
        echo "Local IP: "(ip route get 1.1.1.1 | grep -oP 'src \K\S+')
        echo "DNS: "(grep nameserver /etc/resolv.conf | awk '{print $2}' | head -1)
    end

    if command -v starship >/dev/null
        starship init fish | source
    end

    function fish_greeting
        set_color cyan
        echo "╭────────────────────────────────────────────────────────────╮"
        set_color normal
        set_color --bold blue
        printf "│ 🚀 %-55s │\n" "Zypher Terminal - Enhanced Experience"
        set_color normal
        set_color yellow
        printf "│ 📅 %-55s │\n" (date "+%A, %B %d, %Y at %I:%M %p")
        set_color normal
        set_color green
        set -l uptime_info (cat /proc/uptime | cut -d' ' -f1)
        set -l uptime_hours (math "floor($uptime_info / 3600)")
        set -l uptime_minutes (math "floor(($uptime_info % 3600) / 60)")
        printf "│ 💾 %-55s │\n" "Uptime: $uptime_hours hours, $uptime_minutes minutes"
        set_color normal
        set_color magenta
        set -l host_name (cat /etc/hostname 2>/dev/null || echo "Unknown")
        printf "│ 🖥️ %-55s │\n" "Host: $host_name"
        set_color normal
        set_color red
        printf "│ 👤 %-55s │\n" "User: $USER"
        set_color normal
        set_color blue
        printf "│ 🐚 %-55s │\n" "Shell: Fish "(fish --version | string match -r '\d+\.\d+\.\d+')
        set_color normal
        set_color cyan
        echo "╰────────────────────────────────────────────────────────────╯"
        set_color normal
        echo
        set_color --dim white
        echo "💡 Tips: Use 'sysinfo' for detailed system info (Fastfetch)"
        set_color normal
        echo
    end

    set -gx PATH $HOME/.local/bin $PATH

    if command -v zoxide >/dev/null
        zoxide init fish | source
    end

    if command -v thefuck >/dev/null
        thefuck --alias | source
    end
end
