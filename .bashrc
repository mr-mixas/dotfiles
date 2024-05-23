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
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\[\033[01;33m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt

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
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

######## additional exports #########
export EDITOR='vim'
export LANGUAGE=C.UTF-8 # disable gettext's translations to curtrent LANG or LC_ALL
export LC_ALL=C.UTF-8

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

# export env vars from gnome-keyring
if [ "${SSH_AGENT_LAUNCHER}" = 'gnome-keyring' -a -x /usr/bin/secret-tool ]; then
    # to set new auto-exported secret use
    # `secret-tool store --label=<HUMAN_READABLE> set_env_mode shell set_env_name <VAR_NAME>`

    cur_key=''
    var_name=''
    var_value=''

    # attrs in stderr
    found="$(/usr/bin/secret-tool search --all set_env_mode shell 2>&1)"

    for tok in $(echo "${found}" | awk 'NF == 3 {print $1, $3}'); do
        if [ -z "${cur_key}" ]; then
            cur_key=$tok
        else
            if [ "${cur_key}" = 'attribute.set_env_name' ]; then
                var_name=$tok
            elif [ "${cur_key}" = 'secret' ]; then
                var_value=$tok
            fi
            cur_key=''

            if [ -n "${var_name}" -a -n "${var_value}" ]; then
                export ${var_name}=${var_value}
                var_name=''
                var_value=''
            fi
        fi
    done
fi
