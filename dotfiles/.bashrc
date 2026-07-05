# My .bashrc and .profile :)

git_prompt_status() {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [ -z "$branch" ]; then
        return
    fi

    local status=""
    # Check for unstaged changes (*)
    if ! git diff --quiet 2>/dev/null; then
        status="${status}*"
    fi
    # Check for untracked files (?)
    if [ -n "$(git ls-files --others --exclude-standard 2>/dev/null)" ]; then
        status="${status}?"
    fi

    echo "$branch${status}"
}

prompt_status() {
    local prompt='[\[\e[36m\]λ\[\e[0m\]:\[\e[34m\]\w'
    local gitout=$(git_prompt_status)

    if [ -z "$gitout" ]; then
        prompt="${prompt}\[\e[0m\]]\n> "
    else
        prompt="${prompt}\[\e[0m\]@\[\e[32m\]${gitout}\[\e[0m\]]\n> "
    fi

    PS1=${prompt}
}

export PROMPT_COMMAND=prompt_status

export _JAVA_AWT_WM_NONREPARENTING=1

export XDG_CONFIG_HOME=${HOME}/.config
export XDG_CACHE_HOME=${HOME}/.cache
export XDG_DATA_HOME=${HOME}/.local/share
export XDG_STATE_HOME=${HOME}/.local/state

export PATH=${PATH}:~/bin
export PATH=${PATH}:~/.local/bin
export PATH=${PATH}:~/puter/scriptz
export PATH=${PATH}:~/.cargo/bin
export LSP_USE_PLISTS=true
export EDITOR="emacsclient -c -a emacs"
export VISUAL="emacsclient -c -a emacs"
export TERMINAL="alacritty"
export BROWSER="firefox"
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export LESSHISTFILE=".history"

export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

export MPD_HOST="localhost"
export MPD_PORT="6969"

alias cls="tput reset"
alias ls='ls --color=auto'
alias ll="ls -lah"
alias grep='grep --color=auto'
alias tmux="tmux -2"

## Shit added by other clowns.

# opencode
export PATH=/home/adam/.opencode/bin:$PATH
