#!/bin/zsh

ln -s $PWD/zsh/.zshrc $HOME/.zshrc
ln -s $PWD/wezterm/.wezterm.lua $HOME/.wezterm.lua
ln -s $PWD/mise/.default-gems $HOME/.default-gems
ln -s $PWD/mise/.default-go-packages $HOME/.default-go-packages

mkdir -p $HOME/.config
ln -s $PWD/nvim $HOME/.config/nvim
