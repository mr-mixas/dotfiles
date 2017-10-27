# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=15000
HISTFILESIZE=15000
HISTTIMEFORMAT='[%F_%T]  '

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lah='ls -lh'

# other aliases
which md5sum >/dev/null && alias md5='md5sum'
alias svn_kw='svn ps svn:keywords "Id HeadURL Header"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

######## additional exports #########
export EDITOR='vim'
export LANGUAGE=C.UTF-8 # disable gettext's translations to curtrent LANG or LC_ALL
export LC_ALL=C.UTF-8

######## perl related ########
[ -s ~/perl5/perlbrew/etc/bashrc ] && \
    source ~/perl5/perlbrew/etc/bashrc

######## general purposes functions #########

# convert unixtime to human readable form
date_r() {
    if [ `uname` = Linux ]; then
        date -d @${1}
    else # FreeBSD
        date -r ${1}
    fi
}

# git batch for all subdirs
gitb() {
    for d in *; do
        [ -d ${d} ] || continue
        echo "./${d}"
        git -C ${d}/ $@
    done
}

alias pullall='gitb pull'
alias statall='gitb status --short'
