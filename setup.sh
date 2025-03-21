#!/bin/zsh

ln -s $PWD/zsh/.zshrc $HOME/.zshrc
ln -s $PWD/wezterm/.wezterm.lua $HOME/.wezterm.lua

mkdir -p $HOME/.config
ln -s $PWD/nvim $HOME/.config/nvim
