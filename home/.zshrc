# zsh on arch will source /etc/profile from /etc/zsh/zprofile which is run after .zshenv, so need to set path here
typeset -U path
[[ -d ~/bin ]] && path=(~/bin "$path[@]")
[[ -d ~/src/robbieg.bin ]] && path=("$path[@]" ~/src/robbieg.bin)
[[ -d ~/src/atlassian-scripts ]] && path=("$path[@]" ~/src/atlassian-scripts/bin)

# shell agnostic function returns true if ${1} is a valid executable, function etc.
function isAThing() {
    return $(type "${1}" > /dev/null 2>&1)
}

# execute tmux if it isn't running; it will replace this process with a new login shell
if [ -z "${TMUX}" ] && isAThing tmux; then
    exec tmux
fi

# moar history
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

# vim CLI mode
bindkey -v

# boot the zsh completion system 
autoload -Uz compinit
compinit

# bindings for insert mode
bindkey "^J" history-beginning-search-forward
bindkey "^K" history-beginning-search-backward

# aliases
local os=$(uname)
if [ "${os}" = "Linux" ]; then
    alias ls="ls --color"
elif [ "${os}" = "Darwin" -o "${os}" = "FreeBSD" ]; then
    alias ls="ls -G"
else
    alias ls="ls -F"
fi
alias ll="ls -lh"
alias lla="ll -a"
alias grep="grep --color"
alias rgrep="find . -type f -print0 | xargs -0 grep"
alias diff="diff --color"
if [ -d ~/src/git-scripts ]; then
    alias git-merge-poms='git mergetool --tool=versions -y'
fi
if isAThing ipmitool; then
    alias ipmi="ipmitool -U ${USER} -I lanplus -H 192.168.10.7"
    alias ipmiConsoleAct="TERM=vt100; ipmi sol activate"
    alias ipmiConsoleDeact="ipmi sol deactivate"
    alias ipmiBios="ipmi chassis bootparam set bootflag force_bios"
fi
unset os

# select host prompt colour from: black, red, green, yellow, blue, magenta, cyan, white
local promptColour
case "$(hostname)" in
emperor*)
    promptColour="yellow"
    ;;
gigantor*)
    promptColour="blue"
    ;;
lord*)
    promptColour="magenta"
    ;;
* )
    promptColour="green"
    ;;
esac

# root prompt is always red
if [ "${USER}" = "root" ]; then
    promptColour="red"
fi

# prompt:
#   bg red background nonzero return code and newline
#   bg host background coloured ":; " in black text
PS1="%(?..%F{black}%K{red}%?%k%f"$'\n'")%F{black}%K{${promptColour}}:;%k%f "
PS2="%K{${promptColour}}:; %_%k "

# title pwd and __git_ps1 (if present)
#   "\e]0;" ESC xterm (title) code
#   "\a"    BEL
[[ -f /usr/share/git/completion/git-prompt.sh ]] && . /usr/share/git/completion/git-prompt.sh
if isAThing __git_ps1; then

    # show extra flags
    export GIT_PS1_SHOWDIRTYSTATE=true
    export GIT_PS1_SHOWSTASHSTATE=true
    precmd() {
        printf "\e]0;%s%s\a" "${PWD}" "$(__git_ps1)"
    }
else
    precmd() {
        printf "\e]0;%s\a" "${PWD}"
    }
fi
unset promptColour

# user mount helpers
if isAThing udisksctl; then
    mnt() {
        if [ ${#} -ne 1 ]; then
            echo "Usage: ${FUNCNAME} <block device>" >&2
            return 1
        fi
        udisksctl mount -b ${1} && cd "$(findmnt -n -o TARGET ${1})"
    }
    umnt() {
        if [ ${#} -ne 1 ]; then
            echo "Usage: ${FUNCNAME} <block device>" >&2
            return 1
        fi
        udisksctl unmount -b ${1}
    }
fi

# use the keychain wrapper to start ssh-agent if needed, using the RSA key for "alex"
if isAThing keychain; then
	eval $(keychain --eval --quiet --agents ssh ~alex/.ssh/id_rsa)
fi
