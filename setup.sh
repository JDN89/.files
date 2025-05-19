#!/usr/bin/env bash

echo "🔗 Linking configs..."

# Fish
echo "Linking ~/.files/.config/fish -> ~/.config/fish"
ln -sfn "$HOME/.files/.config/fish" "$HOME/.config/fish"

# Ghostty
echo "Linking ~/.files/.config/ghostty -> ~/.config/ghostty"
ln -sfn "$HOME/.files/.config/ghostty" "$HOME/.config/ghostty"

# Lazygit
echo "Linking ~/.files/.config/lazygit -> ~/.config/lazygit"
ln -sfn "$HOME/.files/.config/lazygit" "$HOME/.config/lazygit"

# Neofetch
echo "Linking ~/.files/.config/neofetch -> ~/.config/neofetch"
ln -sfn "$HOME/.files/.config/neofetch" "$HOME/.config/neofetch"

# Neovim
echo "Linking ~/.files/.config/nvim -> ~/.config/nvim"
ln -sfn "$HOME/.files/.config/nvim" "$HOME/.config/nvim"

echo "📁 Ensuring ~/.files/.local/share exists..."
mkdir -p "$HOME/.files/.local/share"

# Move fonts if not symlink
if [ -d "$HOME/.local/share/fonts" ] && [ ! -L "$HOME/.local/share/fonts" ]; then
    echo "📦 Moving ~/.local/share/fonts to ~/.files/.local/share/fonts"
    mv "$HOME/.local/share/fonts" "$HOME/.files/.local/share/fonts"
fi

mkdir -p "$HOME/.local/share"

# Backup existing fonts if needed
if [ -e "$HOME/.local/share/fonts" ] && [ ! -L "$HOME/.local/share/fonts" ]; then
    echo "🗂 Backing up existing ~/.local/share/fonts"
    mv "$HOME/.local/share/fonts" "$HOME/.local/share/fonts_backup_$(date +%s)"
fi

# Link fonts
echo "Linking ~/.files/.local/share/fonts -> ~/.local/share/fonts"
ln -sfn "$HOME/.files/.local/share/fonts" "$HOME/.local/share/fonts"

# Refresh fonts
echo "🔄 Refreshing font cache..."
fc-cache -f

# Ensure ~/.local/bin is in PATH
mkdir -p "$HOME/.local/bin"

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    export PATH="$HOME/.local/bin:$PATH"
    echo "✅ Added ~/.local/bin to PATH"
fi

# Symlink buildnvim
if [ -f "$HOME/.files/.local/bin/buildnvim.sh" ]; then
    chmod +x "$HOME/.files/.local/bin/buildnvim.sh"
    ln -sf "$HOME/.files/.local/bin/buildnvim.sh" "$HOME/.local/bin/buildnvim"
    echo "✅ Linked buildnvim"
else
    echo "⚠️ buildnvim.sh not found"
fi

echo "✅ Setup complete!"

