#!/bin/zsh

function link_file()
{
  if [ ! -f "$2" ]; then
    ln -s $1 $2
  fi
}

function link_files_in_dir()
{
  cd $1

  for file in *; do
    if [ ! -f "$2/$file" ]; then
      ln -s $1/$file $2/$file
    fi
  done

  cd -
}

function link_dir()
{
  if [ ! -d "$2" ]; then
    ln -s $1 $2
  fi
}

# Returns the config file for the corresponding host, otherwise generic config based on whether or not we're in WSL
function fetch_wezterm_config()
{
  if [ -f "$PWD/wezterm/.wezterm.$HOST.lua" ]; then
    echo $PWD/wezterm/.wezterm.$HOST.lua
  elif which wslpath &> /dev/null; then
    echo $PWD/wezterm/.wezterm.wsl.lua
  else
    echo $PWD/wezterm/.wezterm.lua
  fi
}

link_file $PWD/zsh/.zshrc $HOME/.zshrc

# Copy wezterm config
# If we're on a Windows machine using WSL, we need to instead link to the Windows home dir, since the app runs from
# Windows itself.
if which wslpath &> /dev/null; then
  win_home=$(wslpath "$(wslvar USERPROFILE)")
  config=$(fetch_wezterm_config)

  cp -rf $config $win_home/.wezterm.lua
else
  config=$(fetch_wezterm_config)

  link_file $config $HOME/.wezterm.lua
fi

link_file $PWD/mise/.default-gems $HOME/.default-gems
link_file $PWD/mise/.default-go-packages $HOME/.default-go-packages

mkdir -p $HOME/.config
link_dir $PWD/nvim $HOME/.config/nvim

link_file $PWD/git/.gitconfig $HOME/.gitconfig

# Needs sudo...
# link_files_in_dir $PWD/bin /usr/local/bin
