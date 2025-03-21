# oh-my-zsh

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"
HIST_STAMPS="yyyy-mm-dd"

plugins=(
  bundler
  dotenv
  git
  gh
  golang
  mise
  rails
  rake
  ruby
  rust
  ssh
  ssh-agent
  sudo
  systemd
)

source $ZSH/oh-my-zsh.sh


# User Configuration

export EDITOR=nvim


# Compilation flags

export RUBY_CONFIGURE_OPTS='--with-jemalloc --enable-yjit'


# Aliases
alias config='/usr/bin/git --git-dir=/home/adam/.cfg/ --work-tree=/home/adam'


# Eval

export GPG_TTY=$(tty)
gpgconf --launch gpg-agent

eval $(ssh-agent)

. "$HOME/.cargo/env"

eval "$(~/.local/bin/mise activate zsh)"

