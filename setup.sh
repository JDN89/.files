#!/usr/bin/env bash

# TODO: next setup from scratch add install scripts
# probably fish first
# then all the requirements for neovim
# then neovim

# Ensure target directory exists in .files
mkdir -p "$HOME/.files/.local/share"

# Move fonts directory if it exists and is not already a symlink
if [ -d "$HOME/.local/share/fonts" ] && [ ! -L "$HOME/.local/share/fonts" ]; then
    echo "Moving ~/.local/share/fonts to ~/.files/.local/share/fonts"
    mv "$HOME/.local/share/fonts" "$HOME/.files/.local/share/fonts"
fi

# Ensure ~/.local/share exists
mkdir -p "$HOME/.local/share"

# Backup existing non-symlink fonts directory, if any
if [ -e "$HOME/.local/share/fonts" ] && [ ! -L "$HOME/.local/share/fonts" ]; then
    echo "Backing up existing ~/.local/share/fonts"
    mv "$HOME/.local/share/fonts" "$HOME/.local/share/fonts_backup_$(date +%s)"
fi

# Create symlink if missing or incorrect
if [ ! -L "$HOME/.local/share/fonts" ]; then
    echo "Creating symlink ~/.local/share/fonts -> ~/.files/.local/share/fonts"
    ln -sf "$HOME/.files/.local/share/fonts" "$HOME/.local/share/fonts"
fi

# Refresh font cache
echo "Refreshing font cache..."
fc-cache -f

# Ensure ~/.local/bin exists and is in PATH
mkdir -p "$HOME/.local/bin"

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"  # or ~/.zshrc
    export PATH="$HOME/.local/bin:$PATH"
    echo "Added ~/.local/bin to PATH"
fi

# Make buildnvim.sh executable and symlink it
BUILDNVIM_SRC="$HOME/.files/.local/bin/buildnvim.sh"
BUILDNVIM_LINK="$HOME/.local/bin/buildnvim"

if [ -f "$BUILDNVIM_SRC" ]; then
    chmod +x "$BUILDNVIM_SRC"
    ln -sf "$BUILDNVIM_SRC" "$BUILDNVIM_LINK"
    echo "Symlinked buildnvim to $BUILDNVIM_LINK"
else
    echo "Warning: buildnvim.sh not found at $BUILDNVIM_SRC"
fi

echo "Done!"
