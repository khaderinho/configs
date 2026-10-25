[[ $- != *i* ]] && return

export PATH="$HOME/.local/bin:$PATH"
export EDITOR='vim'

# Git branch
git_branch() {
  branch=$(git branch --show-current 2>/dev/null)
  if [ -n "$branch" ]; then
    echo " $branch"
  fi
}

# Prompt
PS1='\[\e[92m\]\u \H \[\e[96;1m\]\w\[\e[0m\]\[\e[91m\]$(git_branch)\[\e[0m\] \[\e[95;1m\]>>\[\e[0m\] '

# Vim
set -o vi

# Aliases
alias ls="ls --color"
alias ll="ls -ll"
alias la="ls -la"

alias u="sudo apt update && sudo apt upgrade"
alias s="sudo apt search"
alias i="sudo apt install"
alias r="sudo apt remove"
