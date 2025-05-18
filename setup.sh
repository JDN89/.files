#!/bin/bash

DOTFILES=~/.files


echo "Linking Neovim..."
ln -sfn $DOTFILES/.config/nvim ~/.config/nvim

echo "Linking Fish..."
ln -sfn $DOTFILES/.config/fish ~/.config/fish

echo "Linking ghostty..."
ln -sfn $DOTFILES/.config/ghostty ~/.config/ghostty

echo "Linking lazygit..."
ln -sfn $DOTFILES/.config/lazygit ~/.config/lazygit

echo "Linking neofetch..."
ln -sfn $DOTFILES/.config/neofetch ~/.config/neofetch

echo "Done!"
