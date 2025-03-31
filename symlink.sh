#!/bin/zsh

ln -s $PWD/zsh/.zshrc $HOME/.zshrc


# Copy wezterm config
# If we're on a Windows machine using WSL, we need to instead link to the Windows home dir, since the app runs from
# Windows itself.
if which wslpath &> /dev/null; then
  win_home=$(wslpath "$(wslvar USERPROFILE)")
  cp -rf $PWD/wezterm/.wezterm.wsl.lua  $win_home/.wezterm.lua
else
  ln -s $PWD/wezterm/.wezterm.lua $HOME/.wezterm.lua
fi

ln -s $PWD/mise/.default-gems $HOME/.default-gems
ln -s $PWD/mise/.default-go-packages $HOME/.default-go-packages

mkdir -p $HOME/.config
ln -s $PWD/nvim $HOME/.config/nvim
