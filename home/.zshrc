function isAThing() {
    return $(type "${1}" > /dev/null 2>&1)
}

# local vars
hostName=$(hostname)
newLine=$'\n'
os=$(uname)
promptColour=

# moar history
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

# boot the zsh completion system 
autoload -Uz compinit
compinit

# vim CLI mode
bindkey -v

# bindings for insert mode
bindkey "^J" history-beginning-search-forward
bindkey "^K" history-beginning-search-backward

# aliases
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
if [ -d ~/src/git-scripts ]; then
    alias git-merge-poms='git mergetool --tool=versions -y'
fi
alias ipmi="ipmitool -U ${USER} -I lanplus -H 192.168.10.7"
alias ipmiConsoleAct="TERM=vt100; ipmi sol activate"
alias ipmiConsoleDeact="ipmi sol deactivate"
alias ipmiBios="ipmi chassis bootparam set bootflag force_bios"

# select host prompt colour from: black, red, green, yellow, blue, magenta, cyan, white
case "${hostName}" in
emperor*)
    promptColour="green"
    ;;
duke*)
    promptColour="cyan"
    ;;
gigantor*)
    promptColour="blue"
    ;;
prince*)
    promptColour="yellow"
    ;;
* )
    promptColour="magenta"
    ;;
esac

# prompt:
#   bg red nonzero return code and newline
#   bg host coloured ":; "
PROMPT="%(?..%K{red}%?%k${newLine})%K{${promptColour}}:;%k "

# title pwd and __git_ps1 (if present)
#   "\e]0;" ESC xterm (title) code
#   "\a"    BEL xterm (title) code
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

# complete PATH
typeset -U path
[[ -d ~/src/robbieg.bin ]] && path=(~/src/robbieg.bin "$path[@]")
[[ -d ~/src/atlassian-scripts ]] && path=(~/src/atlassian-scripts/bin "$path[@]")
[[ -d ~/bin ]] && path=(~/bin "$path[@]")

# clear local vars
unset hostName
unset newLine
unset os
unset promptColour
