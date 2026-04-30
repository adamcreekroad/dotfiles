#!/bin/zsh

if which apt &> /dev/null; then
  OS='DEB Linux'
elif which dnf &> /dev/null; then
  OS='RPM Linux'
elif [[ "$(uname -s)" = "Darwin" ]]; then
  OS='Darwin'
else
  echo "Not a supported OS!"
  exit 1
fi

echo "Detected $OS, continuing..."

# Setup ZSH
echo "Setting up ZSH plugins"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install homebrew
if [[ "$OS" = "Darwin" && -v $(which brew &> /dev/null) ]]; then
  echo "Installing homebrew..."

  /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo "done!"
fi

# Install mise-en-place
if which mise &> /dev/null; then
  echo "mise-en-place already installed"
else
  echo "installing mise-en-place..."

  curl https://mise.run | sh
  eval "$(~/.local/bin/mise activate zsh)"

  echo "done!"
fi

# Install rust
if which rustc &> /dev/null; then
  echo "rust already installed"
else
  echo "installing rust..."

  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

  echo "done!"
fi

# Install ruby

RUBY_VERSION="$(mise ls ruby | awk '{print $2}')"
if [[ -n "$RUBY_VERSION" ]]; then
  echo "ruby $RUBY_VERSION already installed"
else
  echo "installing ruby..."

  if [[ "$OS" == "RPM Linux" ]]; then
    sudo dnf install -y jemalloc-devel libffi-devel libyaml-devel
  elif [[ "$OS" == "DEB Linux" ]]; then
    sudo apt install -y libjemalloc-dev libffi-dev libyaml-dev
  elif [[ "$OS" == "Darwin" ]]; then
    brew install jemalloc libyaml
  fi

  if [[ $? -ne 0 ]]; then
    echo "Failed to install ruby dependencies"
    exit 1
  fi

  mise use -g ruby@latest

  echo "done!"
fi

# Install go
if which go &> /dev/null; then
  echo "go already installed"
else
  echo "installing go..."

  mise use -g go@latest

  echo "done!"
fi

# Install node
NODE_VERSION=$(mise ls node | awk '{print $2}')

if [[ "$NODE_VERSION" =~ ^[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2}$ ]]; then
  echo "node already installed"
else
  echo "installing node..."

  mise use -g node@latest

  echo "done!"
fi

# Install postgres
if which psql &> /dev/null; then
  echo "postgres already installed"
else
  echo "installing postgres"

  if [[ "$OS" == "RPM Linux" ]]; then
    sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/F-41-x86_64/pgdg-fedora-repo-latest.noarch.rpm
    sudo dnf install -y sudo dnf install postgresql postgresql-server postgresql-devel postgresql-contrib

    sudo /usr/bin/postgresql-setup --initdb
    sudo systemctl enable postgresql
    sudo systemctl start postgresql
  elif [[ "$OS" == "Darwin" ]]; then
    brew install postgres
  fi

  echo "done!"
fi

# Install redis
if which redis-cli &> /dev/null; then
  echo "redis already installed"
else
  echo "installing redis"
  
  if [[ "$OS" == "RPM Linux" ]]; then
	  sudo dnf install -y redis
	  sudo systemctl enable redis
	  sudo systemctl start redis
  elif [[ "$OS" == "Darwin" ]]; then
    brew install valkey
  fi

  echo "done!"
fi
