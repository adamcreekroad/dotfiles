# oh-my-zsh

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"
HIST_STAMPS="yyyy-mm-dd"

plugins=(bundler dotenv fzf git gh golang mise node rails rake ruby rust ssh ssh-agent sudo systemd zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh


# User Configuration

export EDITOR=nvim
export BROWSER=ff


# Compilation flags

export RUBY_CONFIGURE_OPTS='--with-jemalloc --enable-yjit'
export RUBY_YJIT_ENABLE='true'


# Aliases

alias g='git'
alias be='bundle exec'

# Functions

# Prune all merged branches
function gprune()
{
  git fetch --prune
  merged_branches=$(git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}')
  git branch -D $merged_branches
}

# Hard reset the current local branch to match remote. Necessary when the remote branch has been force pushed.
function gres()
{
  current_branch=$(git rev-parse --abbrev-ref HEAD)
  git pull
  git reset --hard origin/$current_branch
}

# Pull the default branch
function gpull()
{
  default_branch=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
  current_branch=$(git rev-parse --abbrev-ref HEAD)

  if [[ "$default_branch" == "$current_branch" ]]; then
    git pull
  else
    git checkout $default_branch
    git pull
    git checkout $current_branch
  fi
}


# Eval

export GPG_TTY=$(tty)
gpgconf --launch gpg-agent

. "$HOME/.cargo/env"

eval "$(~/.local/bin/mise activate zsh)"


# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
