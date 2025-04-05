#!/bin/zsh

function link_file()
{
  if [ ! -f "$2" ]; then
    ln -s $1 $2
  fi
}

function link_dir()
{
  if [ ! -d "$2" ]; then
    ln -s $1 $2
  fi
}

link_file $PWD/zsh/.zshrc $HOME/.zshrc

# Copy wezterm config
# If we're on a Windows machine using WSL, we need to instead link to the Windows home dir, since the app runs from
# Windows itself.
if which wslpath &> /dev/null; then
  win_home=$(wslpath "$(wslvar USERPROFILE)")
  cp -rf $PWD/wezterm/.wezterm.wsl.lua  $win_home/.wezterm.lua
else
  link_file $PWD/wezterm/.wezterm.lua $HOME/.wezterm.lua
fi

link_file $PWD/mise/.default-gems $HOME/.default-gems
link_file $PWD/mise/.default-go-packages $HOME/.default-go-packages

mkdir -p $HOME/.config
link_dir $PWD/nvim $HOME/.config/nvim

link_file $PWD/git/.gitconfig $HOME/.gitconfig
